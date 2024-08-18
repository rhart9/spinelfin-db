CREATE TABLE [dbo].[DescriptionTranslation] (
    [DescriptionTranslationID] INT             IDENTITY (1, 1) NOT NULL,
    [Description]              NVARCHAR (1024) NOT NULL,
    [FriendlyDescription]      NVARCHAR (1024) NULL,
    [BudgetItemID]             INT             NULL
);
GO

ALTER TABLE [dbo].[DescriptionTranslation]
    ADD CONSTRAINT [PK_BankDescriptionTranslation] PRIMARY KEY CLUSTERED ([DescriptionTranslationID] ASC);
GO

ALTER TABLE [dbo].[DescriptionTranslation]
    ADD CONSTRAINT [FK_BankDescriptionTranslation_BudgetItem] FOREIGN KEY ([BudgetItemID]) REFERENCES [budget].[BudgetItem] ([BudgetItemID]);
GO

