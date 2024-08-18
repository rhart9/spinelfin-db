CREATE TABLE [budget].[MonthlyBudget] (
    [MonthlyBudgetID]         INT      IDENTITY (1, 1) NOT NULL,
    [BudgetItemID]            INT      NOT NULL,
    [BudgetAmount]            MONEY    NOT NULL,
    [MatchAmount]             MONEY    NULL,
    [AccountID]               INT      NULL,
    [MonthID]                 INT      NOT NULL,
    [OriginalCurrentBudgetID] INT      NULL,
    [AmountFrequency]         CHAR (1) CONSTRAINT [DF_MonthlyBudget_Frequency] DEFAULT ('M') NOT NULL,
    [ReconFrequency]          CHAR (1) NULL,
    CONSTRAINT [PK_MonthlyBudget] PRIMARY KEY CLUSTERED ([MonthlyBudgetID] ASC),
    CONSTRAINT [FK_MonthlyBudget_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_MonthlyBudget_BudgetItem] FOREIGN KEY ([BudgetItemID]) REFERENCES [budget].[BudgetItem] ([BudgetItemID]),
    CONSTRAINT [FK_MonthlyBudget_CategoryMonth] FOREIGN KEY ([MonthID]) REFERENCES [dbo].[CategoryMonth] ([CategoryMonthID])
);
GO

