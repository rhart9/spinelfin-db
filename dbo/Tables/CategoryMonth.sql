CREATE TABLE [dbo].[CategoryMonth] (
    [CategoryMonthID]     INT  IDENTITY (1, 1) NOT NULL,
    [YearValue]           INT  NOT NULL,
    [MonthValue]          INT  NOT NULL,
    [StartDate]           DATE NOT NULL,
    [EndDate]             DATE NULL,
    [FirstOfMonth]        AS   (datefromparts([YearValue],[MonthValue],(1))),
    [YearValueNextMonth]  AS   (case when [MonthValue]=(12) then [YearValue]+(1) else [YearValue] end),
    [MonthValueNextMonth] AS   (case when [MonthValue]=(12) then (1) else [MonthValue]+(1) end),
    CONSTRAINT [PK_Month] PRIMARY KEY CLUSTERED ([CategoryMonthID] ASC)
);
GO

