--DECLARE @Category nvarchar(255)

--SELECT @Category = '[No Category]'
--SELECT @Category = 'D01'

CREATE FUNCTION [dbo].[fnCategoryReportOther]
(	
	@Category nvarchar(255)
)
RETURNS TABLE 
AS
RETURN 
(
	WITH cte_Records AS (
		SELECT at.AccountID, at.FriendlyDescription AS Description, at.TransactionDate AS ReferenceDate, ats.TransactionSplitID, at.TransactionID, at.PaymentTransactionID, at.TransactionID AS ReferenceID, at.Amount
		FROM AccountTransaction at
		INNER JOIN AccountTransactionSplit ats ON at.TransactionID = ats.TransactionID
		UNION
		SELECT zr.AccountID, NULL AS Description, zr.ReferenceDate, ats.TransactionSplitID, NULL AS TransactionID, NULL AS PaymentTransactionID, zr.ZeroRecordID AS ReferenceID, 0 AS Amount
		FROM ZeroRecord zr
		INNER JOIN AccountTransactionSplit ats ON zr.ZeroRecordID = ats.ZeroRecordID
	)
	SELECT 
		r.ReferenceDate, 
		a.AccountName, 
		CASE WHEN r.TransactionID IS NULL THEN s.Description
			WHEN ISNULL(s.Description, '') <> '' THEN r.Description + ' | ' + s.Description
			ELSE r.Description
		END AS Description,
		CASE WHEN r.Amount <> s.Amount AND r.TransactionID IS NOT NULL THEN 'X' ELSE '' END AS P,
		CASE WHEN r.TransactionID IS NULL THEN 'X' ELSE '' END AS Z,
		CASE WHEN s.Amount >= 0 THEN CAST(s.Amount AS nvarchar) ELSE '' END AS Credit, 
		CASE WHEN s.Amount < 0 THEN CAST(s.Amount * -1 AS nvarchar) ELSE '' END AS Debit, 
		SUM(s.Amount) OVER (ORDER BY r.ReferenceDate, s.TransactionSplitID) AS Balance, 
		r.ReferenceID, 
		s.TransactionSplitID
	FROM dbo.AccountTransactionSplit s
	INNER JOIN cte_Records r ON s.TransactionSplitID = r.TransactionSplitID
	LEFT OUTER JOIN dbo.Account a ON a.AccountID = r.AccountID
	LEFT OUTER JOIN dbo.vCategory c ON s.CategoryID = c.CategoryID
	WHERE COALESCE(c.ReconGroupDescription, c.Description, '[No Category]') = @Category
	AND r.PaymentTransactionID IS NULL
	AND NOT EXISTS (SELECT TOP 1 1 FROM AccountTransaction at2 WHERE at2.PaymentTransactionID = r.ReferenceID AND r.Description <> 'Zero Record')
)
--ORDER BY r.ReferenceDate, s.TransactionSplitID
GO

