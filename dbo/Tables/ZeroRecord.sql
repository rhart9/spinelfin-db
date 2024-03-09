CREATE TABLE [dbo].[ZeroRecord] (
    [ZeroRecordID]  INT            IDENTITY (1, 1) NOT NULL,
    [AccountID]     INT            NOT NULL,
    [ReferenceDate] DATE           NOT NULL,
    [Notes]         NVARCHAR (MAX) NULL,
    [InLegacy]     BIT            NOT NULL
);
GO

ALTER TABLE [dbo].[ZeroRecord]
    ADD CONSTRAINT [DF_ZeroRecord_InLegacy] DEFAULT ((0)) FOR [InLegacy];
GO

ALTER TABLE [dbo].[ZeroRecord]
    ADD CONSTRAINT [PK_ZeroRecord] PRIMARY KEY CLUSTERED ([ZeroRecordID] ASC);
GO

ALTER TABLE [dbo].[ZeroRecord]
    ADD CONSTRAINT [FK_ZeroRecord_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]);
GO

