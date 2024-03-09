CREATE TABLE [dbo].[AccountTransactionSplit] (
    [TransactionSplitID]   INT             IDENTITY (1, 1) NOT NULL,
    [TransactionID]        INT             NULL,
    [ZeroRecordID]         INT             NULL,
    [CategoryID]           INT             NULL,
    [Amount]               MONEY           NOT NULL,
    [ReferenceDate]        DATE            NULL,
    [Description]          NVARCHAR (1024) NULL,
    [PaymentTransactionID] INT             NULL,
    [LegacyCategory]      NVARCHAR (1024) NULL
);
GO

ALTER TABLE [dbo].[AccountTransactionSplit]
    ADD CONSTRAINT [FK_AccountTransactionSplitID_AccountTransaction1] FOREIGN KEY ([PaymentTransactionID]) REFERENCES [dbo].[AccountTransaction] ([TransactionID]);
GO

ALTER TABLE [dbo].[AccountTransactionSplit]
    ADD CONSTRAINT [FK_AccountTransactionSplitID_Category] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Category] ([CategoryID]);
GO

ALTER TABLE [dbo].[AccountTransactionSplit]
    ADD CONSTRAINT [FK_AccountTransactionSplitID_AccountTransaction] FOREIGN KEY ([TransactionID]) REFERENCES [dbo].[AccountTransaction] ([TransactionID]);
GO

ALTER TABLE [dbo].[AccountTransactionSplit]
    ADD CONSTRAINT [FK_AccountTransactionSplit_ZeroRecord] FOREIGN KEY ([ZeroRecordID]) REFERENCES [dbo].[ZeroRecord] ([ZeroRecordID]);
GO

ALTER TABLE [dbo].[AccountTransactionSplit]
    ADD CONSTRAINT [CK_AccountTransactionSplit] CHECK (NOT ([TransactionID] IS NULL AND [ZeroRecordID] IS NULL));
GO

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE TRIGGER AccountTransactionSplitInsertUpdateTrigger 
   ON dbo.AccountTransactionSplit 
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IsClosed bit

	SELECT @IsClosed = c.IsClosed
	FROM inserted i
	INNER JOIN Category c ON i.CategoryID = c.CategoryID

	IF @IsClosed = 1
	BEGIN
		RAISERROR('Cannot assign a closed category to a transaction split', 16, 1)
		ROLLBACK
	END

END
GO

ALTER TABLE [dbo].[AccountTransactionSplit]
    ADD CONSTRAINT [PK_AccountTransactionSplitID] PRIMARY KEY CLUSTERED ([TransactionSplitID] ASC);
GO

