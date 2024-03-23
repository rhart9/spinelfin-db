CREATE TABLE [dbo].[AccountTransaction] (
    [TransactionID]           INT             IDENTITY (1, 1) NOT NULL,
    [AccountID]               INT             NOT NULL,
    [TransactionSerialNumber] INT             NULL,
    [TransactionDate]         DATE            NOT NULL,
    [BankDescription]         NVARCHAR (1024) NULL,
    [FriendlyDescription]     NVARCHAR (1024) NULL,
    [Amount]                  MONEY           NOT NULL,
    [Balance]                 MONEY           NULL,
    [Reconciled]              BIT             CONSTRAINT [DF_AccountTransaction_Reconciled] DEFAULT ((0)) NOT NULL,
    [Cleared]                 BIT             CONSTRAINT [DF_AccountTransaction_Cleared] DEFAULT ((0)) NOT NULL,
    [CheckNumber]             NVARCHAR (10)   NULL,
    [LegacyMemo]              NVARCHAR (1024) NULL,
    [LegacyCheckNumber]       NVARCHAR (10)   NULL,
    [LegacySpinelfinRef]      INT             NULL,
    [CreatedDT]               DATETIME        CONSTRAINT [DF_AccountTransaction_CreatedDT] DEFAULT (getdate()) NOT NULL,
    [UpdatedDT]               DATETIME        CONSTRAINT [DF_AccountTransaction_UpdatedDT] DEFAULT (getdate()) NOT NULL,
    [ProcessedInLegacy]       BIT             CONSTRAINT [DF_AccountTransaction_ProcessedInLegacy] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AccountTransaction] PRIMARY KEY CLUSTERED ([TransactionID] ASC),
    CONSTRAINT [FK_AccountTransaction_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID])
);
GO

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE TRIGGER [dbo].[AccountTransactionDeleteTrigger]
   ON [dbo].[AccountTransaction] 
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DelReconciled bit

	SELECT @DelReconciled = d.Reconciled
	FROM deleted d

	IF @DelReconciled = 1
	BEGIN
		RAISERROR('Cannot delete a reconciled transaction', 16, 1)
		ROLLBACK
	END

END
GO

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE TRIGGER [dbo].[AccountTransactionInsertUpdateTrigger]
   ON [dbo].[AccountTransaction] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CurrAccountID int, @PrevTransactionSerialNumber int, @CurrTransactionSerialNumber int, @CurrAmount money, @PrevBalance money, @CurrBalance money
	DECLARE @InsReconciled bit, @DelReconciled bit

	DECLARE @Error nvarchar(1024)

	SELECT @CurrAccountID = i.AccountID, 
			@CurrTransactionSerialNumber = i.TransactionSerialNumber,
			@CurrAmount = i.Amount,
			@CurrBalance = i.Balance,
			@InsReconciled = i.Reconciled
	FROM inserted i

	SELECT @DelReconciled = d.Reconciled
	FROM deleted d

	IF @DelReconciled = 1
	BEGIN
		IF UPDATE(Reconciled)
		BEGIN
			RAISERROR('Cannot unreconcile a reconciled transaction', 16, 1)
			ROLLBACK
			RETURN
		END
		IF UPDATE(TransactionSerialNumber) OR UPDATE(Amount) OR UPDATE(Balance) OR UPDATE(AccountID)
		BEGIN
			RAISERROR('Cannot update account, serial number, amount or balance of a reconciled transaction', 16, 1)
			ROLLBACK
			RETURN
		END
	END
	ELSE IF @InsReconciled = 1
	BEGIN
		SELECT @PrevTransactionSerialNumber = MAX(at.TransactionSerialNumber)
		FROM AccountTransaction at
		WHERE at.AccountID = @CurrAccountID AND at.TransactionSerialNumber <> @CurrTransactionSerialNumber

		

		IF @CurrTransactionSerialNumber IS NULL OR ISNULL(@PrevTransactionSerialNumber, 0) + 1 <> @CurrTransactionSerialNumber
		BEGIN
			SELECT @Error = 'Serial number is not sequential: Previous serial number ' + CAST(@PrevTransactionSerialNumber as nvarchar) + ', Current serial number ' + CAST(@CurrTransactionSerialNumber as nvarchar)

			RAISERROR(@Error, 16, 1)
			ROLLBACK
			RETURN
		END

		SELECT @PrevBalance = at.Balance
		FROM AccountTransaction at
		WHERE at.TransactionSerialNumber = @PrevTransactionSerialNumber

		DECLARE @ExpectedBalance money
		SELECT @ExpectedBalance = ISNULL(@PrevBalance, 0) + @CurrAmount

		IF @CurrBalance IS NULL OR @ExpectedBalance <> @CurrBalance
		BEGIN
			SELECT @Error = 'Balance does not match expected balance: Previous balance ' + CAST(@PrevBalance as nvarchar) + ', Current amount ' + CAST(@CurrAmount as nvarchar) + ', Expected balance ' + CAST(@ExpectedBalance as nvarchar) + ', Current balance ' + CAST(@CurrBalance as nvarchar)

			RAISERROR(@Error, 16, 1)
			ROLLBACK
			RETURN
		END
	END
	ELSE
	BEGIN
		IF @CurrTransactionSerialNumber IS NOT NULL OR @CurrBalance IS NOT NULL
		BEGIN
			RAISERROR('Cannot set serial number or balance on an unreconciled transaction', 16, 1)
			ROLLBACK
			RETURN
		END
	END
END
GO




ALTER TABLE [dbo].[AccountTransaction]
    ADD CONSTRAINT [DF_AccountTransaction_ProcessedInLegacy] DEFAULT ((0)) FOR [ProcessedInLegacy];
GO

