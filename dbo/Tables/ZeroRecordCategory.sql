CREATE TABLE [dbo].[ZeroRecordCategory] (
    [ZeroRecordCategoryID] INT            IDENTITY (1, 1) NOT NULL,
    [CategoryName]         NVARCHAR (100) NULL
);
GO

ALTER TABLE [dbo].[ZeroRecordCategory]
    ADD CONSTRAINT [PK_ZeroRecordCategory] PRIMARY KEY CLUSTERED ([ZeroRecordCategoryID] ASC);
GO

