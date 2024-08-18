CREATE TABLE [dbo].[AccountTransaction] (
    [TransactionID]            INT             IDENTITY (1, 1) NOT NULL,
    [AccountID]                INT             NOT NULL,
    [TransactionSerialNumber]  INT             NULL,
    [TransactionDate]          DATE            NOT NULL,
    [BankDescription]          NVARCHAR (1024) NULL,
    [FriendlyDescription]      NVARCHAR (1024) NULL,
    [Amount]                   MONEY           NOT NULL,
    [Reconciled]               BIT             CONSTRAINT [DF_AccountTransaction_Reconciled] DEFAULT ((0)) NOT NULL,
    [Cleared]                  BIT             CONSTRAINT [DF_AccountTransaction_Cleared] DEFAULT ((0)) NOT NULL,
    [CheckNumber]              NVARCHAR (10)   NULL,
    [LegacyMemo]               NVARCHAR (1024) NULL,
    [LegacyCheckNumber]        NVARCHAR (10)   NULL,
    [LegacySpinelfinRef]       INT             NULL,
    [CreatedDT]                DATETIME        CONSTRAINT [DF_AccountTransaction_CreatedDT] DEFAULT (getdate()) NOT NULL,
    [UpdatedDT]                DATETIME        CONSTRAINT [DF_AccountTransaction_UpdatedDT] DEFAULT (getdate()) NOT NULL,
    [ProcessedInLegacy]        BIT             CONSTRAINT [DF_AccountTransaction_ProcessedInLegacy] DEFAULT ((0)) NOT NULL,
    [BankStagingTransactionID] INT             NULL,
    [PaymentTransactionID]     INT             NULL,
    [CreditReasonCategoryID]   INT             NULL,
    [CreditReason]             NVARCHAR (256)  NULL,
    [BalanceTransferFlag]      BIT             CONSTRAINT [DF_AccountTransaction_BalanceTransferFlag] DEFAULT ((0)) NOT NULL,
    [ExportToLegacy]           BIT             CONSTRAINT [DF_AccountTransaction_ExportToLegacy] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AccountTransaction] PRIMARY KEY CLUSTERED ([TransactionID] ASC),
    CONSTRAINT [FK_AccountTransaction_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_AccountTransaction_AccountTransaction] FOREIGN KEY ([PaymentTransactionID]) REFERENCES [dbo].[AccountTransaction] ([TransactionID]),
    CONSTRAINT [FK_AccountTransaction_BankStagingTransaction] FOREIGN KEY ([BankStagingTransactionID]) REFERENCES [dbo].[BankStagingTransaction] ([BankStagingTransactionID]),
    CONSTRAINT [FK_AccountTransaction_CreditReasonCategory] FOREIGN KEY ([CreditReasonCategoryID]) REFERENCES [dbo].[CreditReasonCategory] ([CreditReasonCategoryID])
);
GO

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
