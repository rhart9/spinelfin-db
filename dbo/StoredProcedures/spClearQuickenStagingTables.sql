CREATE PROCEDURE dbo.spClearLegacyStagingTables
AS
BEGIN
	;DELETE FROM LegacyStagingTransactionSplit
	;DELETE FROM LegacyStagingTransaction
	;DELETE FROM LegacyStagingZeroRecord
END
GO

