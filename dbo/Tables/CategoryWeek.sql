CREATE TABLE [dbo].[CategoryWeek] (
    [CategoryWeekID] INT  IDENTITY (1, 1) NOT NULL,
    [MonthID]        INT  NOT NULL,
    [StartDate]      DATE NOT NULL,
    [EndDate]        DATE NOT NULL
);
GO

ALTER TABLE [dbo].[CategoryWeek]
    ADD CONSTRAINT [PK_Week] PRIMARY KEY CLUSTERED ([CategoryWeekID] ASC);
GO

ALTER TABLE [dbo].[CategoryWeek]
    ADD CONSTRAINT [FK_Week_Month] FOREIGN KEY ([MonthID]) REFERENCES [dbo].[CategoryMonth] ([CategoryMonthID]);
GO

