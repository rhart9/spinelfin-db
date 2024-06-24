CREATE TABLE [dbo].[ZeroRecordCategory] (
    [ZeroRecordCategoryID]       INT            IDENTITY (1, 1) NOT NULL,
    [CategoryName]               NVARCHAR (16)  NULL,
    [CategoryDescription]        NVARCHAR (255) NULL,
    [ExpectedNumSplitRows]       INT            NULL,
    [ExpectedCategoryTypeID1]    INT            NULL,
    [ExpectedCategoryTypeID2]    INT            NULL,
    [ExpectedCategoryID2]        INT            NULL,
    [ExpectedCategory2NextMonth] BIT            NULL,
    [OpenMonthFlag]              BIT            CONSTRAINT [DF_ZeroRecordCategory_OpenMonthFlag] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ZeroRecordCategory] PRIMARY KEY CLUSTERED ([ZeroRecordCategoryID] ASC),
    CONSTRAINT [FK_ZeroRecordCategory_Category] FOREIGN KEY ([ExpectedCategoryID2]) REFERENCES [dbo].[Category] ([CategoryID]),
    CONSTRAINT [FK_ZeroRecordCategory_CategoryType] FOREIGN KEY ([ExpectedCategoryTypeID1]) REFERENCES [dbo].[CategoryType] ([CategoryTypeID]),
    CONSTRAINT [FK_ZeroRecordCategory_CategoryType1] FOREIGN KEY ([ExpectedCategoryTypeID2]) REFERENCES [dbo].[CategoryType] ([CategoryTypeID])
);
GO



