CREATE TABLE [dbo].[ZeroRecordCategory] (
    [ZeroRecordCategoryID]              INT             IDENTITY (1, 1) NOT NULL,
    [CategoryName]                      NVARCHAR (16)   NULL,
    [CategoryDescription]               NVARCHAR (255)  NULL,
    [ExpectedNumSplitRows]              INT             NULL,
    [ExpectedCategoryTypeID1]           INT             NULL,
    [ExpectedCategoryTypeID2]           INT             NULL,
    [ExpectedCategoryID2]               INT             NULL,
    [OpenMonthFlag]                     BIT             CONSTRAINT [DF_ZeroRecordCategory_OpenMonthFlag] DEFAULT ((0)) NOT NULL,
    [UseExpectedCategoryTypeSameMonth]  BIT             CONSTRAINT [DF_ZeroRecordCategory_UseExpectedCategoryTypeSameMonth] DEFAULT ((0)) NOT NULL,
    [UseExpectedCategoryTypeNextMonth]  BIT             CONSTRAINT [DF_ZeroRecordCategory_UseExpectedCategoryTypeNextMonth] DEFAULT ((0)) NOT NULL,
    [UseExpectedCategory]               BIT             CONSTRAINT [DF_ZeroRecordCategory_UseExpectedCategory] DEFAULT ((0)) NOT NULL,
    [UseMonthlyReconCategory]           BIT             CONSTRAINT [DF_ZeroRecordCategory_UseMonthlyReconCategory] DEFAULT ((0)) NOT NULL,
    [UseMonthlyReconCategoryIfNegative] BIT             CONSTRAINT [DF_ZeroRecordCategory_UseMonthlyReconCategoryIfNegative] DEFAULT ((0)) NOT NULL,
    [SplitDescription1]                 NVARCHAR (1024) NULL,
    [SplitDescription2]                 NVARCHAR (1024) NULL,
    [Multiplier]                        INT             CONSTRAINT [DF_ZeroRecordCategory_Multiplier] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ZeroRecordCategory] PRIMARY KEY CLUSTERED ([ZeroRecordCategoryID] ASC),
    CONSTRAINT [FK_ZeroRecordCategory_Category] FOREIGN KEY ([ExpectedCategoryID2]) REFERENCES [dbo].[Category] ([CategoryID]),
    CONSTRAINT [FK_ZeroRecordCategory_CategoryType] FOREIGN KEY ([ExpectedCategoryTypeID1]) REFERENCES [dbo].[CategoryType] ([CategoryTypeID]),
    CONSTRAINT [FK_ZeroRecordCategory_CategoryType1] FOREIGN KEY ([ExpectedCategoryTypeID2]) REFERENCES [dbo].[CategoryType] ([CategoryTypeID])
);
GO




