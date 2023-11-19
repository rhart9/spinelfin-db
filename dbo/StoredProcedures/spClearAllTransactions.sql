-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[spClearAllTransactions] 
AS
BEGIN
	;DISABLE TRIGGER AccountTransactionDeleteTrigger ON AccountTransaction
	
	;DELETE FROM AccountTransactionSplit
	
	;DELETE FROM AccountTransaction

	;DELETE FROM ZeroRecord
	
	;ENABLE TRIGGER AccountTransactionDeleteTrigger ON AccountTransaction
END
GO

