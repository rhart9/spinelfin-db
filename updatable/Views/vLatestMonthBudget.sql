






CREATE VIEW [updatable].[vLatestMonthBudget] AS
	WITH cte_Month AS (
		SELECT mb.MonthID, CAST(cm.MonthValue AS nvarchar) + '/' + CAST(cm.YearValue AS nvarchar) AS MonthText, ROW_NUMBER() OVER (ORDER BY cm.YearValue DESC, cm.MonthValue DESC) AS RowNum
		FROM budget.MonthlyBudget mb
		INNER JOIN CategoryMonth cm ON mb.MonthID = cm.CategoryMonthID
	)
	SELECT m.MonthText, bi.Name, mb.BudgetAmount AS BudgetAmt4, mb.BudgetAmount5Week AS BudgetAmt5, mb.MatchAmount AS MatchAmt4, mb.MatchAmount5Week AS MatchAmt5, a.AccountName AS Acct, mb.AmountFrequency AS AmtFreq, mb.ReconFrequency AS ReconFreq, mb.ScheduledDay AS Day
	FROM budget.MonthlyBudget mb
	INNER JOIN cte_Month m ON mb.MonthID = m.MonthID AND m.RowNum = 1
	INNER JOIN budget.BudgetItem bi ON mb.BudgetItemID = bi.BudgetItemID
	LEFT OUTER JOIN (
		SELECT DISTINCT AccountID, AccountName FROM Account -- To prevent Account from being updated
	) a ON mb.AccountID = a.AccountID
GO




CREATE TRIGGER [updatable].[vLatestMonthBudgetDeleteTrigger]
	ON [updatable].[vLatestMonthBudget]
	INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	
	WITH cte_Month AS (
		SELECT mb.MonthID, ROW_NUMBER() OVER (ORDER BY cm.YearValue DESC, cm.MonthValue DESC) AS RowNum
		FROM budget.MonthlyBudget mb
		INNER JOIN CategoryMonth cm ON mb.MonthID = cm.CategoryMonthID
	)
	DELETE mb
	FROM budget.MonthlyBudget mb
	INNER JOIN cte_Month m ON mb.MonthID = m.MonthID AND m.RowNum = 1
	INNER JOIN budget.BudgetItem bi ON mb.BudgetItemID = bi.BudgetItemID
	INNER JOIN deleted d ON bi.Name = d.Name
END
GO

