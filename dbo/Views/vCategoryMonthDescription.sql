

CREATE VIEW [dbo].[vCategoryMonthDescription]
AS
	SELECT c.CategoryID,
		CAST(cm.YearValue AS nvarchar) + '-' + RIGHT('0' + CAST(cm.MonthValue AS nvarchar), 2) AS DateDescription
	FROM dbo.Category c
	INNER JOIN dbo.CategoryType ct ON c.CategoryTypeID = ct.CategoryTypeID
	INNER JOIN dbo.CategoryMonth cm ON c.MonthID = cm.CategoryMonthID
	WHERE ct.CategoryCode IN ('I', 'ME') OR (ct.CategoryCode = 'D' AND c.WeekID IS NULL)
GO

