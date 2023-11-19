CREATE TABLE [dbo].[ImportedTransaction] (
    [ImportedTransactionID] INT             IDENTITY (1, 1) NOT NULL,
    [AccountID]             INT             NOT NULL,
    [TransactionOrder]      INT             NOT NULL,
    [Date]                  DATE            NOT NULL,
    [BankDescription]       NVARCHAR (1024) NULL,
    [Amount]                MONEY           NOT NULL
);
GO

ALTER TABLE [dbo].[ImportedTransaction]
    ADD CONSTRAINT [PK_ImportedTransaction] PRIMARY KEY CLUSTERED ([ImportedTransactionID] ASC);
GO

