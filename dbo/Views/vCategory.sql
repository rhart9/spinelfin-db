






CREATE VIEW [dbo].[vCategory]   
AS
	SELECT c.*, 
		CASE 
			WHEN c.LegacyCategoryName IS NOT NULL THEN c.LegacyCategoryName
			WHEN cwd.CategoryID IS NOT NULL THEN cwd.DateDescription + ' ' + ct.CategoryTypeDescription
			WHEN cmd.CategoryID IS NOT NULL THEN cmd.DateDescription + ' ' + ct.CategoryTypeDescription
			ELSE 'Category ' + CAST(c.CategoryID AS nvarchar)
		END AS Description,
		CASE
			WHEN cmd.CategoryID IS NOT NULL AND ct.ReconGroup IS NOT NULL THEN cmd.DateDescription + ' ' + ct.ReconGroup
		END AS ReconGroupDescription
	FROM dbo.Category c
	INNER JOIN dbo.CategoryType ct ON c.CategoryTypeID = ct.CategoryTypeID
	LEFT OUTER JOIN dbo.vCategoryMonthDescription cmd ON c.CategoryID = cmd.CategoryID
	LEFT OUTER JOIN dbo.vCategoryWeekDescription cwd ON c.CategoryID = cwd.CategoryID
GO

