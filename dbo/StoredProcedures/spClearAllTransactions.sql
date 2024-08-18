-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[spClearAllTransactions] 
AS
BEGIN
	;DELETE FROM AccountTransactionSplit
	
	;DELETE FROM AccountTransaction

	;DELETE FROM ZeroRecord
END
GO

