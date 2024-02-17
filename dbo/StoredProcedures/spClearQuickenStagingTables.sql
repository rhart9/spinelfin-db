CREATE PROCEDURE dbo.spClearQuickenStagingTables
AS
BEGIN
	;DELETE FROM QuickenStagingTransactionSplit
	;DELETE FROM QuickenStagingTransaction
	;DELETE FROM QuickenStagingZeroRecord
END
GO

