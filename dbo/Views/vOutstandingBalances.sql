CREATE VIEW [dbo].[vOutstandingBalances]  
AS
	SELECT a.AccountName, COALESCE(c.ReconGroupDescription, c.Description, '[No Category]') AS Category, SUM(s.Amount) AS Amount, CASE WHEN (c.IsClosed = 1 OR c.IsClosedInLegacy = 1) THEN 'CLOSED' ELSE '' END AS Closed
	FROM dbo.AccountTransactionSplit s
	LEFT OUTER JOIN dbo.AccountTransaction t ON s.TransactionID = t.TransactionID
	LEFT OUTER JOIN dbo.ZeroRecord z ON s.ZeroRecordID = z.ZeroRecordID
	LEFT OUTER JOIN dbo.Account a ON a.AccountID = ISNULL(t.AccountID, z.AccountID)
	LEFT OUTER JOIN dbo.vCategory c ON s.CategoryID = c.CategoryID
	GROUP BY a.AccountName, COALESCE(c.ReconGroupDescription, c.Description, '[No Category]'), c.IsClosed, c.IsClosedInLegacy
	HAVING SUM(s.Amount) <> 0
GO

