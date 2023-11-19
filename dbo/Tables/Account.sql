CREATE TABLE [dbo].[Account] (
    [AccountID]       INT           IDENTITY (1, 1) NOT NULL,
    [Description]     NVARCHAR (50) NOT NULL,
    [CreditCard]      BIT           NOT NULL,
    [ImportAlgorithm] NVARCHAR (50) NULL,
    [SkipFirstLine]   BIT           NOT NULL,
    [ReverseSign]     BIT           NOT NULL
);
GO

ALTER TABLE [dbo].[Account]
    ADD CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED ([AccountID] ASC);
GO

