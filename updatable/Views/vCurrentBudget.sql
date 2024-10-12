



CREATE VIEW [updatable].[vCurrentBudget] AS
	SELECT bi.Name, cb.BudgetAmount AS BudgetAmt4, cb.BudgetAmount5Week AS BudgetAmt5, cb.MatchAmount AS MatchAmt4, cb.MatchAmount5Week AS MatchAmt5, a.AccountName AS Acct, cb.AmountFrequency AS AmtFreq, cb.ReconFrequency AS ReconFreq, cb.ScheduledDay AS DayOfMo, cb.DayOffset AS Offset, CAST(NULL as nvarchar) AS 'AddToCur?'
	FROM budget.CurrentBudget cb
	INNER JOIN budget.BudgetItem bi ON cb.BudgetItemID = bi.BudgetItemID
	LEFT OUTER JOIN (
		SELECT DISTINCT AccountID, AccountName FROM Account -- To prevent Account from being updated
	) a ON cb.AccountID = a.AccountID
GO




CREATE TRIGGER [updatable].[vCurrentBudgetInsertTrigger]
	ON [updatable].[vCurrentBudget]
	INSTEAD OF INSERT
AS
BEGIN
	DECLARE @BudgetItemID int, @AddToCurrentMonth bit
	DECLARE @AccountID int = NULL
	
	DECLARE @LatestBudgetMonthID int, @CurrentBudgetID int

	SELECT @BudgetItemID = bi.BudgetItemID
	FROM budget.BudgetItem bi
	INNER JOIN inserted i ON bi.Name = i.Name
	WHERE (bi.ThruDate IS NULL OR bi.ThruDate > GETDATE())

	SELECT @AddToCurrentMonth = CASE WHEN i.[AddToCur?] IS NULL THEN 0 ELSE 1 END
	FROM inserted i

	SELECT @AccountID = a.AccountID
	FROM Account a
	INNER JOIN inserted i ON a.AWSFileType = i.Acct

	;WITH cte_Months AS (
		SELECT cm.CategoryMonthID, ROW_NUMBER() OVER (ORDER BY cm.FirstOfMonth DESC) AS RowNum
		FROM CategoryMonth cm
		WHERE EXISTS (SELECT TOP 1 1 FROM budget.MonthlyBudget mb WHERE cm.CategoryMonthID = mb.MonthID)
	)
	SELECT @LatestBudgetMonthID = c.CategoryMonthID
	FROM cte_Months c
	WHERE c.RowNum = 1

	IF @BudgetItemID IS NULL
	BEGIN
		DECLARE @FromDate date

		IF @LatestBudgetMonthID IS NOT NULL
		BEGIN
			SELECT @FromDate = CASE WHEN @AddToCurrentMonth = 1 THEN cm.FirstOfMonth ELSE DATEADD(m, 1, cm.FirstOfMonth) END
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

	INSERT INTO budget.CurrentBudget(BudgetItemID, BudgetAmount, BudgetAmount5Week, MatchAmount, MatchAmount5Week, AccountID, AmountFrequency, ReconFrequency, ScheduledDay, DayOffset)
	SELECT bi.BudgetItemID, i.BudgetAmt4, i.BudgetAmt5, i.MatchAmt4, i.MatchAmt5, bi.AccountID, ISNULL(i.AmtFreq, 'M'), ISNULL(i.ReconFreq, 'M'), i.DayOfMo, i.Offset
	FROM budget.BudgetItem bi, inserted i
	WHERE bi.BudgetItemID = @BudgetItemID

	SELECT @CurrentBudgetID = SCOPE_IDENTITY()

	IF @AddToCurrentMonth = 1
	BEGIN
		DECLARE @CategoryMonthID int, @WeekCount int

		SELECT @CategoryMonthID = cm.CategoryMonthID, @WeekCount = COUNT(*)
		FROM CategoryMonth cm
		INNER JOIN CategoryWeek cw ON cm.CategoryMonthID = cw.MonthID
		WHERE cm.CategoryMonthID = @LatestBudgetMonthID
		GROUP BY cm.CategoryMonthID

		INSERT INTO budget.MonthlyBudget(BudgetItemID, BudgetAmount, MatchAmount, AccountID, MonthID, OriginalCurrentBudgetID, AmountFrequency, ReconFrequency, ScheduledDay, DayOffset)
		SELECT bi.BudgetItemID, CASE WHEN @WeekCount = 5 AND i.BudgetAmt5 IS NOT NULL THEN i.BudgetAmt5 ELSE i.BudgetAmt4 END, CASE WHEN @WeekCount = 5 AND i.MatchAmt5 IS NOT NULL THEN i.MatchAmt5 ELSE i.MatchAmt4 END, bi.AccountID, @LatestBudgetMonthID, @CurrentBudgetID, ISNULL(i.AmtFreq, 'M'), ISNULL(i.ReconFreq, 'M'), i.DayOfMo, i.Offset
		FROM budget.BudgetItem bi, inserted i
		WHERE bi.BudgetItemID = @BudgetItemID
	END
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

