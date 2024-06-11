CREATE TABLE [dbo].[ZeroRecordCategory] (
    [ZeroRecordCategoryID]    INT            IDENTITY (1, 1) NOT NULL,
    [CategoryName]            NVARCHAR (16)  NULL,
    [CategoryDescription]     NVARCHAR (255) NULL,
    [FromDate]                DATE           NULL,
    [ThruDate]                DATE           NULL,
    [ExpectedNumSplitRows]    INT            NULL,
    [ExpectedCategoryTypeID1] INT            NULL,
    [ExpectedCategoryTypeID2] INT            NULL,
    CONSTRAINT [PK_ZeroRecordCategory] PRIMARY KEY CLUSTERED ([ZeroRecordCategoryID] ASC),
    CONSTRAINT [FK_ZeroRecordCategory_CategoryType] FOREIGN KEY ([ExpectedCategoryTypeID1]) REFERENCES [dbo].[CategoryType] ([CategoryTypeID]),
    CONSTRAINT [FK_ZeroRecordCategory_CategoryType1] FOREIGN KEY ([ExpectedCategoryTypeID2]) REFERENCES [dbo].[CategoryType] ([CategoryTypeID])
);
GO

ALTER TABLE [dbo].[ZeroRecordCategory]
    ADD CONSTRAINT [FK_ZeroRecordCategory_CategoryType] FOREIGN KEY ([ExpectedCategoryTypeID1]) REFERENCES [dbo].[CategoryType] ([CategoryTypeID]);
GO


ALTER TABLE [dbo].[ZeroRecordCategory]
    ADD CONSTRAINT [FK_ZeroRecordCategory_CategoryType1] FOREIGN KEY ([ExpectedCategoryTypeID2]) REFERENCES [dbo].[CategoryType] ([CategoryTypeID]);
GO

