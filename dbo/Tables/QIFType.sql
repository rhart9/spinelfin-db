CREATE TABLE [dbo].[QIFType] (
    [QIFTypeID]   INT           IDENTITY (1, 1) NOT NULL,
    [QIFType]     NVARCHAR (10) NOT NULL,
    [AccountType] NVARCHAR (10) NULL,
    CONSTRAINT [PK_QIFType] PRIMARY KEY CLUSTERED ([QIFTypeID] ASC)
);
GO

