CREATE TABLE [dbo].[ZeroRecordCategory] (
    [ZeroRecordCategoryID] INT            IDENTITY (1, 1) NOT NULL,
    [CategoryName]         NVARCHAR (16)  NULL,
    [CategoryDescription]  NVARCHAR (255) NULL,
    CONSTRAINT [PK_ZeroRecordCategory] PRIMARY KEY CLUSTERED ([ZeroRecordCategoryID] ASC)
);
GO

ALTER TABLE [dbo].[ZeroRecordCategory]
    ADD CONSTRAINT [PK_ZeroRecordCategory] PRIMARY KEY CLUSTERED ([ZeroRecordCategoryID] ASC);
GO

