-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[spInsertTransactionFromQuicken] 
	@AccountName nvarchar(50),
	@TransactionDate date,
	@FriendlyDescription nvarchar(1024),
	@Amount money,
	@Reconciled bit,
	@QuickenCheckNumber nvarchar(10),
	@QuickenMemo nvarchar(1024)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @AccountID int
	DECLARE @CheckNumber nvarchar(10)
	DECLARE @PrevSerialNumber int
	DECLARE @SerialNumber int
	DECLARE @PrevBalance money
	DECLARE @Balance money

    SELECT @AccountID = a.AccountID
	FROM Account a
	WHERE a.AccountName = @AccountName

	IF ISNUMERIC(@QuickenCheckNumber) = 1 AND CAST(@QuickenCheckNumber AS int) BETWEEN 200 AND 6000
	BEGIN
		SELECT @CheckNumber = @QuickenCheckNumber
	END
	ELSE
	BEGIN
		SELECT @CheckNumber = NULL
	END

	IF @Reconciled = 1
	BEGIN
		WITH cte_Transactions AS (
			SELECT at.TransactionSerialNumber, at.Balance, ROW_NUMBER() OVER (ORDER BY at.TransactionSerialNumber DESC) AS RowNum
			FROM AccountTransaction at
			WHERE at.AccountID = @AccountID
		)
		SELECT @PrevSerialNumber = c.TransactionSerialNumber, @PrevBalance = c.Balance
		FROM cte_Transactions c
		WHERE RowNum = 1

		SELECT @SerialNumber = ISNULL(@PrevSerialNumber, 0) + 1
		SELECT @Balance = ISNULL(@PrevBalance, 0) + @Amount
	END

	INSERT INTO AccountTransaction(AccountID, TransactionSerialNumber, TransactionDate, FriendlyDescription, Amount, Balance, Reconciled, CheckNumber, InQuicken, QuickenMemo, QuickenCheckNumber)
	VALUES(@AccountID, @SerialNumber, @TransactionDate, @FriendlyDescription, @Amount, @Balance, @Reconciled, @CheckNumber, 1, @QuickenMemo, @QuickenCheckNumber)

	SELECT @@IDENTITY AS TransactionID
END
GO

