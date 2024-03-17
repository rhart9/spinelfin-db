CREATE TABLE [dbo].[ZeroRecord] (
    [ZeroRecordID]       INT            IDENTITY (1, 1) NOT NULL,
    [AccountID]          INT            NOT NULL,
    [ReferenceDate]      DATE           NOT NULL,
    [Notes]              NVARCHAR (MAX) NULL,
    [LegacySpinelfinRef] INT            NULL,
    [Reconciled]         BIT            NULL,
    CONSTRAINT [PK_ZeroRecord] PRIMARY KEY CLUSTERED ([ZeroRecordID] ASC),
    CONSTRAINT [FK_ZeroRecord_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID])
);
GO

