CREATE TABLE [budget].[CurrentBudget] (
    [CurrentBudgetID]   INT            IDENTITY (1, 1) NOT NULL,
    [BudgetItemID]      INT            NOT NULL,
    [BudgetAmount]      DECIMAL (9, 2) NOT NULL,
    [BudgetAmount5Week] DECIMAL (9, 2) NULL,
    [MatchAmount]       DECIMAL (9, 2) NULL,
    [MatchAmount5Week]  DECIMAL (9, 2) NULL,
    [AccountID]         INT            NULL,
    [AmountFrequency]   CHAR (1)       CONSTRAINT [DF_CurrentBudget_Frequency] DEFAULT ('M') NOT NULL,
    [ReconFrequency]    CHAR (1)       NULL,
    [ScheduledDay]      INT            NULL,
    CONSTRAINT [PK_CurrentBudget] PRIMARY KEY CLUSTERED ([CurrentBudgetID] ASC),
    CONSTRAINT [FK_CurrentBudget_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_CurrentBudget_BudgetItem] FOREIGN KEY ([BudgetItemID]) REFERENCES [budget].[BudgetItem] ([BudgetItemID])
);
GO

