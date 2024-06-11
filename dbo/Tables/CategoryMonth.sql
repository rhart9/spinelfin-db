CREATE TABLE [dbo].[CategoryMonth] (
    [CategoryMonthID] INT  IDENTITY (1, 1) NOT NULL,
    [YearValue]       INT  NOT NULL,
    [MonthValue]      INT  NOT NULL,
    [StartDate]       DATE NOT NULL,
    [EndDate]         DATE NULL,
    [FirstOfMonth]    AS   (datefromparts([YearValue],[MonthValue],(1))),
    CONSTRAINT [PK_Month] PRIMARY KEY CLUSTERED ([CategoryMonthID] ASC)
);
GO

ALTER TABLE [dbo].[CategoryMonth]
    ADD CONSTRAINT [PK_Month] PRIMARY KEY CLUSTERED ([CategoryMonthID] ASC);
GO

