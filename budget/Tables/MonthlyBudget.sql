CREATE TABLE [budget].[MonthlyBudget] (
    [MonthlyBudgetID]         INT   IDENTITY (1, 1) NOT NULL,
    [BudgetItemID]            INT   NOT NULL,
    [Amount]                  MONEY NOT NULL,
    [AccountID]               INT   NOT NULL,
    [MonthID]                 INT   NOT NULL,
    [OriginalCurrentBudgetID] INT   NULL
);
GO

ALTER TABLE [budget].[MonthlyBudget]
    ADD CONSTRAINT [PK_MonthlyBudget] PRIMARY KEY CLUSTERED ([MonthlyBudgetID] ASC);
GO

ALTER TABLE [budget].[MonthlyBudget]
    ADD CONSTRAINT [FK_MonthlyBudget_BudgetItem] FOREIGN KEY ([BudgetItemID]) REFERENCES [budget].[BudgetItem] ([BudgetItemID]);
GO

ALTER TABLE [budget].[MonthlyBudget]
    ADD CONSTRAINT [FK_MonthlyBudget_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]);
GO

ALTER TABLE [budget].[MonthlyBudget]
    ADD CONSTRAINT [FK_MonthlyBudget_CurrentBudget] FOREIGN KEY ([OriginalCurrentBudgetID]) REFERENCES [budget].[CurrentBudget] ([CurrentBudgetID]);
GO

ALTER TABLE [budget].[MonthlyBudget]
    ADD CONSTRAINT [FK_MonthlyBudget_CategoryMonth] FOREIGN KEY ([MonthID]) REFERENCES [dbo].[CategoryMonth] ([CategoryMonthID]);
GO

