CREATE TABLE [dbo].[AccountTransactionSplit] (
    [TransactionSplitID]    INT             IDENTITY (1, 1) NOT NULL,
    [TransactionID]         INT             NULL,
    [ZeroRecordID]          INT             NULL,
    [CategoryID]            INT             NULL,
    [Amount]                MONEY           NOT NULL,
    [ReferenceDate]         DATE            NULL,
    [Description]           NVARCHAR (1024) NULL,
    [LegacyCategory]        NVARCHAR (1024) NULL,
    [Subcategory]           NVARCHAR (255)  NULL,
    [Notes]                 NVARCHAR (MAX)  NULL,
    [MonthlyBudgetID]       INT             NULL,
    [OriginalTransactionID] INT             NULL,
    [OriginalZeroRecordID]  INT             NULL,
    CONSTRAINT [PK_AccountTransactionSplitID] PRIMARY KEY CLUSTERED ([TransactionSplitID] ASC),
    CONSTRAINT [FK_AccountTransactionSplit_AccountTransaction] FOREIGN KEY ([OriginalTransactionID]) REFERENCES [dbo].[AccountTransaction] ([TransactionID]),
    CONSTRAINT [FK_AccountTransactionSplit_MonthlyBudget] FOREIGN KEY ([MonthlyBudgetID]) REFERENCES [budget].[MonthlyBudget] ([MonthlyBudgetID]),
    CONSTRAINT [FK_AccountTransactionSplit_ZeroRecord] FOREIGN KEY ([ZeroRecordID]) REFERENCES [dbo].[ZeroRecord] ([ZeroRecordID]),
    CONSTRAINT [FK_AccountTransactionSplit_ZeroRecord1] FOREIGN KEY ([OriginalZeroRecordID]) REFERENCES [dbo].[ZeroRecord] ([ZeroRecordID]),
    CONSTRAINT [FK_AccountTransactionSplitID_AccountTransaction] FOREIGN KEY ([TransactionID]) REFERENCES [dbo].[AccountTransaction] ([TransactionID]),
    CONSTRAINT [FK_AccountTransactionSplitID_Category] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Category] ([CategoryID])
);
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



