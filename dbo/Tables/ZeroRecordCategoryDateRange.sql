CREATE TABLE [dbo].[ZeroRecordCategoryDateRange] (
    [ZeroRecordCategoryDateRangeID] INT            IDENTITY (1, 1) NOT NULL,
    [ZeroRecordCategoryID]          INT            NOT NULL,
    [FromDate]                      DATE           NOT NULL,
    [ThruDate]                      DATE           NULL,
    [Notes]                         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_ZeroRecordCategoryDateRange] PRIMARY KEY CLUSTERED ([ZeroRecordCategoryDateRangeID] ASC),
    CONSTRAINT [FK_ZeroRecordCategoryDateRange_ZeroRecordCategory] FOREIGN KEY ([ZeroRecordCategoryID]) REFERENCES [dbo].[ZeroRecordCategory] ([ZeroRecordCategoryID])
);
GO

ALTER TABLE [dbo].[ZeroRecordCategoryDateRange]
    ADD CONSTRAINT [PK_ZeroRecordCategoryDateRange] PRIMARY KEY CLUSTERED ([ZeroRecordCategoryDateRangeID] ASC);
GO

ALTER TABLE [dbo].[ZeroRecordCategoryDateRange]
    ADD CONSTRAINT [FK_ZeroRecordCategoryDateRange_ZeroRecordCategory] FOREIGN KEY ([ZeroRecordCategoryID]) REFERENCES [dbo].[ZeroRecordCategory] ([ZeroRecordCategoryID]);
GO

