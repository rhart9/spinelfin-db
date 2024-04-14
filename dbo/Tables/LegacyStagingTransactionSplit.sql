CREATE TABLE [dbo].[LegacyStagingTransactionSplit] (
    [ImportedTransactionID] INT             NULL,
    [ImportedZeroRecordID]  INT             NULL,
    [CategoryName]          NVARCHAR (255)  NULL,
    [Amount]                DECIMAL (10, 2) NULL,
    [ReferenceDate]         DATE            NULL,
    [Description]           NVARCHAR (1024) NULL,
    [IsMonthlyCategory]     AS              (case when isnumeric(substring([CategoryName],(1),(4)))=(1) AND substring([CategoryName],(5),(1))='-' AND isnumeric(substring([CategoryName],(6),(2)))=(1) then (1) else (0) end)
);
GO

