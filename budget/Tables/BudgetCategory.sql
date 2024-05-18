CREATE TABLE [budget].[BudgetCategory] (
    [BudgetCategoryID]       INT           IDENTITY (1, 1) NOT NULL,
    [CategoryName]           NVARCHAR (50) NOT NULL,
    [ParentBudgetCategoryID] INT           NULL
);
GO

ALTER TABLE [budget].[BudgetCategory]
    ADD CONSTRAINT [FK_BudgetCategory_BudgetCategory] FOREIGN KEY ([ParentBudgetCategoryID]) REFERENCES [budget].[BudgetCategory] ([BudgetCategoryID]);
GO

ALTER TABLE [budget].[BudgetCategory]
    ADD CONSTRAINT [PK_BudgetCategory] PRIMARY KEY CLUSTERED ([BudgetCategoryID] ASC);
GO

