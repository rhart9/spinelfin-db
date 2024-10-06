


CREATE VIEW [budget].[vCurrentBudget] AS
	SELECT cb.CurrentBudgetID, bi.BudgetItemID, bi.Name, cb.BudgetAmount, cb.BudgetAmount5Week, cb.MatchAmount, cb.MatchAmount5Week, a.AccountName, cb.AmountFrequency, cb.ReconFrequency, cb.ScheduledDay, cb.DayOffset
	FROM budget.CurrentBudget cb
	INNER JOIN budget.BudgetItem bi ON cb.BudgetItemID = bi.BudgetItemID
	LEFT OUTER JOIN Account a ON cb.AccountID = a.AccountID
GO

