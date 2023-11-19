CREATE TABLE [dbo].[Category] (
    [CategoryID]        INT           IDENTITY (1, 1) NOT NULL,
    [CategoryTypeID]    INT           NOT NULL,
    [MonthID]           INT           NULL,
    [WeekID]            INT           NULL,
    [FormerDescription] NVARCHAR (32) NULL,
    [IsClosed]          BIT           NOT NULL
);
GO

ALTER TABLE [dbo].[Category]
    ADD CONSTRAINT [DF_Category_IsClosed] DEFAULT ((0)) FOR [IsClosed];
GO

ALTER TABLE [dbo].[Category]
    ADD CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED ([CategoryID] ASC);
GO

