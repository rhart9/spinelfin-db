CREATE TABLE [dbo].[LegacyStagingTransactionSplit] (
    [ImportedTransactionID] INT             NULL,
    [ImportedZeroRecordID]  INT             NULL,
    [CategoryName]          NVARCHAR (255)  NULL,
    [Amount]                DECIMAL (10, 2) NULL,
    [ReferenceDate]         DATE            NULL,
    [Description]           NVARCHAR (1024) NULL
);
GO

