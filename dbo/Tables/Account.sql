CREATE TABLE [dbo].[Account] (
    [AccountID]       INT           IDENTITY (1, 1) NOT NULL,
    [AccountName]     NVARCHAR (50) NOT NULL,
    [AWSFileType]     NVARCHAR (50) NULL,
    [CreditCard]      BIT           NOT NULL,
    [ImportAlgorithm] NVARCHAR (50) NULL,
    [SkipFirstLine]   BIT           NOT NULL,
    [ReverseSign]     BIT           NOT NULL,
    [QIFTypeID]       INT           NOT NULL,
    CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED ([AccountID] ASC),
    CONSTRAINT [FK_Account_QIFType] FOREIGN KEY ([QIFTypeID]) REFERENCES [dbo].[QIFType] ([QIFTypeID])
);
GO

