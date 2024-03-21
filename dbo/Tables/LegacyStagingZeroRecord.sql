CREATE TABLE [dbo].[LegacyStagingZeroRecord] (
    [ImportedZeroRecordID] INT            NOT NULL,
    [AccountName]          NVARCHAR (255) NULL,
    [ReferenceDate]        DATE           NULL,
    [Reconciled]           BIT            NULL,
    [LegacySpinelfinRef]   INT            NULL
);
GO

