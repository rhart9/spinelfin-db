CREATE TABLE [dbo].[BankStagingTransaction] (
    [BankStagingTransactionID] INT              IDENTITY (1, 1) NOT NULL,
    [AccountID]                INT              NOT NULL,
    [TransactionDate]          DATE             NOT NULL,
    [Payee]                    NVARCHAR (1024)  NOT NULL,
    [Amount]                   MONEY            NOT NULL,
    [BatchGUID]                UNIQUEIDENTIFIER NULL,
    [CreatedDT]                DATETIME         NOT NULL
);
GO

ALTER TABLE [dbo].[BankStagingTransaction]
    ADD CONSTRAINT [DF_BankTransaction_CreatedDT] DEFAULT (getdate()) FOR [CreatedDT];
GO

ALTER TABLE [dbo].[BankStagingTransaction]
    ADD CONSTRAINT [PK_BankTransaction] PRIMARY KEY CLUSTERED ([BankStagingTransactionID] ASC);
GO

