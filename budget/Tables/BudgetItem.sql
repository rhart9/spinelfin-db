CREATE TABLE [budget].[BudgetItem] (
    [BudgetItemID]     INT            IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (50)  NOT NULL,
    [Description]      NVARCHAR (512) NULL,
    [BudgetCategoryID] INT            NULL,
    [FromDate]         DATE           NOT NULL,
    [ThruDate]         DATE           NULL
);
GO

ALTER TABLE [budget].[BudgetItem]
    ADD CONSTRAINT [FK_BudgetItem_BudgetCategory] FOREIGN KEY ([BudgetCategoryID]) REFERENCES [budget].[BudgetCategory] ([BudgetCategoryID]);
GO

ALTER TABLE [budget].[BudgetItem]
    ADD CONSTRAINT [PK_BudgetItem] PRIMARY KEY CLUSTERED ([BudgetItemID] ASC);
GO

