
CREATE VIEW [updatable].[vAccountTransactionSplit]
AS
	WITH cte_ReferenceID AS (
		SELECT NULL AS AccountTransactionID, ZeroRecordID
		FROM updatable.ZeroRecordID
		UNION
		SELECT AccountTransactionID, NULL AS ZeroRecordID
		FROM updatable.AccountTransactionID
	)
	SELECT ats.TransactionID, ats.ZeroRecordID, ats.CategoryID, ats.Amount, ats.ReferenceDate, ats.Description, ats.LegacyCategory
	FROM AccountTransactionSplit ats
	INNER JOIN cte_ReferenceID c ON (ats.ZeroRecordID = c.ZeroRecordID OR ats.TransactionID = c.AccountTransactionID)
GO

