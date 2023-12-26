CREATE TABLE [dbo].[Category] (
    [CategoryID]          INT            IDENTITY (1, 1) NOT NULL,
    [CategoryTypeID]      INT            NOT NULL,
    [MonthID]             INT            NULL,
    [WeekID]              INT            NULL,
    [CategoryDescription] NVARCHAR (255) NULL,
    [QuickenCategoryName] NVARCHAR (32)  NULL,
    [IsClosed]            BIT            CONSTRAINT [DF_Category_IsClosed] DEFAULT ((0)) NOT NULL,
    [IsClosedInQuicken]   BIT            CONSTRAINT [DF_Category_IsClosedInQuicken] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);
GO


ALTER TABLE [dbo].[Category]
    ADD CONSTRAINT [DF_Category_IsClosedInQuicken] DEFAULT ((0)) FOR [IsClosedInQuicken];
GO

