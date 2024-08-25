



CREATE VIEW updatable.vCurrentBudget AS
	SELECT bi.Name, cb.BudgetAmount, cb.MatchAmount, a.AccountName, cb.AmountFrequency, cb.ReconFrequency
	FROM budget.CurrentBudget cb
	INNER JOIN budget.BudgetItem bi ON cb.BudgetItemID = bi.BudgetItemID
	LEFT OUTER JOIN (
		SELECT DISTINCT AccountID, AccountName FROM Account -- To prevent Account from being updated
	) a ON cb.AccountID = a.AccountID
GO




CREATE TRIGGER updatable.[vCurrentBudgetInsertTrigger]
	ON updatable.vCurrentBudget
	INSTEAD OF INSERT
AS
BEGIN
	DECLARE @BudgetItemID int
	DECLARE @AccountID int = NULL

	SELECT @BudgetItemID = bi.BudgetItemID
	FROM budget.BudgetItem bi
	INNER JOIN inserted i ON bi.Name = i.Name
	WHERE (bi.ThruDate IS NULL OR bi.ThruDate > GETDATE())

	SELECT @AccountID = a.AccountID
	FROM Account a
	INNER JOIN inserted i ON a.AWSFileType = i.AccountName

	IF @BudgetItemID IS NULL
	BEGIN
		DECLARE @FromDate date
		DECLARE @LatestBudgetMonthID int

		;WITH cte_Months AS (
			SELECT cm.CategoryMonthID, ROW_NUMBER() OVER (ORDER BY cm.FirstOfMonth DESC) AS RowNum
			FROM CategoryMonth cm
			WHERE EXISTS (SELECT TOP 1 1 FROM budget.MonthlyBudget mb WHERE cm.CategoryMonthID = mb.MonthID)
		)
		SELECT @LatestBudgetMonthID = c.CategoryMonthID
		FROM cte_Months c
		WHERE c.RowNum = 1

		IF @LatestBudgetMonthID IS NOT NULL
		BEGIN
			SELECT @FromDate = DATEADD(m, 1, cm.FirstOfMonth)
			FROM CategoryMonth cm
			WHERE cm.CategoryMonthID = @LatestBudgetMonthID
		END
		ELSE
		BEGIN
			SELECT @FromDate = MAX(cm.FirstOfMonth)
			FROM CategoryMonth cm
		END


		INSERT INTO budget.BudgetItem(Name, AccountID, FromDate)
		SELECT i.Name, @AccountID, @FromDate
		FROM inserted i

		SELECT @BudgetItemID = SCOPE_IDENTITY()
	END

	INSERT INTO budget.CurrentBudget(BudgetItemID, BudgetAmount, MatchAmount, AccountID, AmountFrequency, ReconFrequency)
	SELECT bi.BudgetItemID, i.BudgetAmount, i.MatchAmount, bi.AccountID, ISNULL(i.AmountFrequency, 'M'), i.ReconFrequency
	FROM budget.BudgetItem bi, inserted i
	WHERE bi.BudgetItemID = @BudgetItemID
END
GO



CREATE TRIGGER [updatable].[vCurrentBudgetDeleteTrigger]
	ON updatable.vCurrentBudget
	INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	DELETE cb
	FROM budget.CurrentBudget cb
	INNER JOIN budget.BudgetItem bi ON cb.BudgetItemID = bi.BudgetItemID
	INNER JOIN deleted d ON bi.Name = d.Name
END
GO

