



CREATE VIEW [dbo].[vCategoryWeekDescription]  
AS
	SELECT c.CategoryID,
		CAST(cm.YearValue AS nvarchar) + '-' + RIGHT('0' + CAST(cm.MonthValue AS nvarchar), 2) + ' Week ' + CAST(cw.WeekNumber AS nvarchar) AS DateDescription
	FROM dbo.Category c
	INNER JOIN dbo.CategoryType ct ON c.CategoryTypeID = ct.CategoryTypeID
	INNER JOIN dbo.CategoryMonth cm ON c.MonthID = cm.CategoryMonthID
	INNER JOIN dbo.vCategoryWeek cw ON c.WeekID = cw.CategoryWeekID
	WHERE ct.CategoryCode = 'D'
GO

