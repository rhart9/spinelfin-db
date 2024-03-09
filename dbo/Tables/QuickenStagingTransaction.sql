CREATE TABLE [dbo].[LegacyStagingTransaction] (
    [ImportedTransactionID] INT             NOT NULL,
    [AccountName]           NVARCHAR (255)  NULL,
    [TransactionDate]       DATE            NULL,
    [FriendlyDescription]   NVARCHAR (1024) NULL,
    [Amount]                DECIMAL (10, 2) NULL,
    [Reconciled]            BIT             NULL,
    [Cleared]               BIT             NULL,
    [LegacyCheckNumber]    NVARCHAR (255)  NULL,
    [LegacyMemo]           NVARCHAR (255)  NULL
);
GO

