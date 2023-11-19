

CREATE VIEW [dbo].[vCategoryWeek] WITH SCHEMABINDING
AS
	SELECT cw.CategoryWeekID, 
		cw.MonthID, 
		DATEDIFF(ww, cm.StartDate, cw.StartDate) + 1 AS WeekNumber,
		cw.StartDate, 
		cw.EndDate
	FROM dbo.CategoryWeek cw
	INNER JOIN dbo.CategoryMonth cm ON cw.MonthID = cm.CategoryMonthID
GO

