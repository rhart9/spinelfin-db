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
