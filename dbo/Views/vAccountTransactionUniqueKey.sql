CREATE VIEW [dbo].[vAccountTransactionUniqueKey]  WITH SCHEMABINDING
AS
SELECT at.AccountID, at.TransactionSerialNumber
FROM dbo.AccountTransaction at
WHERE at.TransactionSerialNumber IS NOT NULL
GO

