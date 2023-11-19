CREATE TABLE [dbo].[CategoryType] (
    [CategoryTypeID]          INT           IDENTITY (1, 1) NOT NULL,
    [CategoryTypeDescription] NVARCHAR (50) NOT NULL,
    [CategoryCode]            NVARCHAR (2)  NULL,
    [ReconGroup]              NVARCHAR (50) NULL
);
GO

ALTER TABLE [dbo].[CategoryType]
    ADD CONSTRAINT [PK_CategoryType] PRIMARY KEY CLUSTERED ([CategoryTypeID] ASC);
GO

