CREATE TABLE [budget].[CurrentBudget] (
    [CurrentBudgetID] INT            IDENTITY (1, 1) NOT NULL,
    [BudgetItemID]    INT            NOT NULL,
    [Amount]          DECIMAL (9, 2) NOT NULL,
    [AccountID]       INT            NOT NULL
);
GO

ALTER TABLE [budget].[CurrentBudget]
    ADD CONSTRAINT [PK_CurrentBudget] PRIMARY KEY CLUSTERED ([CurrentBudgetID] ASC);
GO

ALTER TABLE [budget].[CurrentBudget]
    ADD CONSTRAINT [FK_CurrentBudget_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]);
GO

ALTER TABLE [budget].[CurrentBudget]
    ADD CONSTRAINT [FK_CurrentBudget_BudgetItem] FOREIGN KEY ([BudgetItemID]) REFERENCES [budget].[BudgetItem] ([BudgetItemID]);
GO

