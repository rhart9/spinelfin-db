CREATE TABLE [dbo].[BankStagingTransaction] (
    [BankStagingTransactionID] INT              IDENTITY (1, 1) NOT NULL,
    [AccountID]                INT              NOT NULL,
    [TransactionDate]          DATE             NOT NULL,
    [Payee]                    NVARCHAR (1024)  NOT NULL,
    [Amount]                   MONEY            NOT NULL,
    [BatchGUID]                UNIQUEIDENTIFIER NULL,
    [CreatedDT]                DATETIME         CONSTRAINT [DF_BankTransaction_CreatedDT] DEFAULT (getdate()) NOT NULL,
    [CategoryName]             NVARCHAR (255)   NULL,
    [SubcategoryName]          NVARCHAR (255)   NULL,
    [SplitDescription]         NVARCHAR (1024)  NULL,
    CONSTRAINT [PK_BankTransaction] PRIMARY KEY CLUSTERED ([BankStagingTransactionID] ASC)
);
GO

ALTER TABLE [dbo].[BankStagingTransaction]
    ADD CONSTRAINT [DF_BankTransaction_CreatedDT] DEFAULT (getdate()) FOR [CreatedDT];
GO

ALTER TABLE [dbo].[BankStagingTransaction]
    ADD CONSTRAINT [PK_BankTransaction] PRIMARY KEY CLUSTERED ([BankStagingTransactionID] ASC);
GO

