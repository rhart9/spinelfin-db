CREATE VIEW [reports].[vCategoryReportRecords]
AS
	WITH cte_Records AS (
		SELECT at.AccountID, at.FriendlyDescription AS Description, at.TransactionDate AS ReferenceDate, ats.TransactionSplitID, at.TransactionID, at.PaymentTransactionID, at.TransactionID AS ReferenceID, at.Amount, at.CheckNumber
		FROM AccountTransaction at
		INNER JOIN AccountTransactionSplit ats ON at.TransactionID = ats.TransactionID
		UNION
		SELECT zr.AccountID, NULL AS Description, zr.ReferenceDate, ats.TransactionSplitID, NULL AS TransactionID, NULL AS PaymentTransactionID, zr.ZeroRecordID AS ReferenceID, 0 AS Amount, NULL AS CheckNumber
		FROM ZeroRecord zr
		INNER JOIN AccountTransactionSplit ats ON zr.ZeroRecordID = ats.ZeroRecordID
	)
	SELECT 
		s.ReferenceDate, 
		a.AccountName, 
		CASE WHEN r.CheckNumber IS NOT NULL THEN r.CheckNumber + ' | ' ELSE '' END +
		CASE WHEN r.TransactionID IS NULL THEN s.Description
			WHEN ISNULL(s.Description, '') <> '' THEN r.Description + ' | ' + s.Description
			ELSE r.Description
		END AS Description,
		CASE WHEN r.Amount <> s.Amount AND r.TransactionID IS NOT NULL THEN 'X' ELSE '' END AS P,
		CASE WHEN r.TransactionID IS NULL THEN 'X' ELSE '' END AS Z,
		s.Amount,
		CASE WHEN s.Amount >= 0 THEN CAST(s.Amount AS nvarchar) ELSE '' END AS Credit, 
		CASE WHEN s.Amount < 0 THEN CAST(s.Amount * -1 AS nvarchar) ELSE '' END AS Debit, 
		r.ReferenceID, 
		s.TransactionSplitID,
		s.CategoryID,
		s.MonthlyBudgetID
	FROM dbo.AccountTransactionSplit s
	INNER JOIN cte_Records r ON s.TransactionSplitID = r.TransactionSplitID
	LEFT OUTER JOIN dbo.Account a ON a.AccountID = r.AccountID
	WHERE r.PaymentTransactionID IS NULL
	AND NOT EXISTS (SELECT TOP 1 1 FROM AccountTransaction at2 WHERE at2.PaymentTransactionID = r.TransactionID)
GO

