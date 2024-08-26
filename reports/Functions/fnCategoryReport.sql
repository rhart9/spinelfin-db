
CREATE FUNCTION [reports].[fnCategoryReport]
(	
	@Category nvarchar(255)
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
		ROW_NUMBER() OVER (ORDER BY r.ReferenceDate, r.TransactionSplitID) AS Sort
	FROM reports.vCategoryReportRecords r
	LEFT OUTER JOIN dbo.vCategory c ON r.CategoryID = c.CategoryID
	WHERE COALESCE(c.ReconGroupDescription, c.Description, '[No Category]') = @Category
)
GO

