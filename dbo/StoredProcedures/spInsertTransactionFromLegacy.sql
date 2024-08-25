-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[spInsertTransactionFromLegacy] 
	@AccountName nvarchar(50),
	@TransactionDate date,
	@FriendlyDescription nvarchar(1024),
	@Amount decimal(9, 2),
	@Reconciled bit,
	@Cleared bit,
	@LegacyCheckNumber nvarchar(10),
	@LegacyMemo nvarchar(1024)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @AccountID int
	DECLARE @CheckNumber nvarchar(10)

    SELECT @AccountID = a.AccountID
	FROM Account a
	WHERE a.AccountName = @AccountName

	IF ISNUMERIC(@LegacyCheckNumber) = 1 AND CAST(@LegacyCheckNumber AS int) BETWEEN 200 AND 6000
	BEGIN
		SELECT @CheckNumber = @LegacyCheckNumber
	END
	ELSE
	BEGIN
		SELECT @CheckNumber = NULL
	END

	INSERT INTO AccountTransaction(AccountID, TransactionDate, FriendlyDescription, Amount, Reconciled, Cleared, CheckNumber, LegacyMemo, LegacyCheckNumber)
	VALUES(@AccountID, @TransactionDate, @FriendlyDescription, @Amount, @Reconciled, @Cleared, @CheckNumber, @LegacyMemo, @LegacyCheckNumber)

	SELECT @@IDENTITY AS TransactionID
END
GO

