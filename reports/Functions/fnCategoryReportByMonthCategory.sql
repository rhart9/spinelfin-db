
CREATE FUNCTION [reports].[fnCategoryReportByMonthCategory]
(	
	@CategoryYear int, 
	@CategoryMonth int,
	@CategoryType nvarchar(50)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		r.ReferenceDate,
		r.AccountName,
		r.Description,
		r.P,
		r.Z,
		r.Amount,
		r.Credit,
		r.Debit,
		r.ReferenceID,
		r.TransactionSplitID,
		ROW_NUMBER() OVER (ORDER BY CASE WHEN r.Amount >= 0 THEN 1 ELSE 2 END, r.ReferenceDate, r.TransactionSplitID) AS Sort
	FROM reports.vCategoryReportRecords r
	LEFT OUTER JOIN dbo.vCategory c ON r.CategoryID = c.CategoryID
	INNER JOIN CategoryMonth cm ON c.MonthID = cm.CategoryMonthID
	INNER JOIN CategoryType ct ON c.CategoryTypeID = ct.CategoryTypeID
	WHERE cm.YearValue = @CategoryYear AND cm.MonthValue = @CategoryMonth AND ct.CategoryTypeDescription = @CategoryType
)
GO

