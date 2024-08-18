CREATE TABLE [budget].[BudgetCategory] (
    [BudgetCategoryID]       INT           IDENTITY (1, 1) NOT NULL,
    [CategoryName]           NVARCHAR (50) NOT NULL,
    [ParentBudgetCategoryID] INT           NULL,
    [Multiplier]             INT           CONSTRAINT [DF_BudgetCategory_Multiplier] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BudgetCategory] PRIMARY KEY CLUSTERED ([BudgetCategoryID] ASC),
    CONSTRAINT [FK_BudgetCategory_BudgetCategory] FOREIGN KEY ([ParentBudgetCategoryID]) REFERENCES [budget].[BudgetCategory] ([BudgetCategoryID])
);
GO

