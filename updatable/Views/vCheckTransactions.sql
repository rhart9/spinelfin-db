
CREATE VIEW [updatable].[vCheckTransactions] AS
	WITH cte_Splits AS (
		SELECT ats.TransactionID, STRING_AGG(CAST(ats.LegacyCategory AS nvarchar(max)), ',') AS Categories
		FROM AccountTransactionSplit ats
		GROUP BY ats.TransactionID
	)
	SELECT at.CheckNumber, at.CheckDate, at.TransactionDate, at.BankDescription, at.FriendlyDescription, at.Amount, at.CheckNumberSequence, s.Categories
	FROM AccountTransaction at
	LEFT OUTER JOIN cte_Splits s ON at.TransactionID = s.TransactionID
	WHERE at.CheckNumber IS NOT NULL
	AND at.TransactionDate > '11/1/17'
GO

