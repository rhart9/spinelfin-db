


CREATE VIEW [budget].[vCurrentBudget] AS
	SELECT cb.CurrentBudgetID, bi.BudgetItemID, bi.Name, cb.BudgetAmount, cb.MatchAmount, a.AccountName, cb.AmountFrequency, cb.ReconFrequency
	FROM budget.CurrentBudget cb
	INNER JOIN budget.BudgetItem bi ON cb.BudgetItemID = bi.BudgetItemID
	LEFT OUTER JOIN Account a ON cb.AccountID = a.AccountID
GO

