
CREATE VIEW [dbo].[vLegacyExport]
AS
	WITH cte_LegacyRecords AS (
		SELECT at.AccountID, at.FriendlyDescription AS Description, at.TransactionDate AS ReferenceDate, at.LegacySpinelfinRef, at.Reconciled, at.Cleared, at.Amount, ats.TransactionSplitID, at.ProcessedInLegacy
		FROM AccountTransaction at
		INNER JOIN AccountTransactionSplit ats ON at.TransactionID = ats.TransactionID
		UNION
		SELECT zr.AccountID, 'Zero Record' AS Description, zr.ReferenceDate, zr.LegacySpinelfinRef, zr.Reconciled, 0 AS Cleared, 0 AS Amount, ats.TransactionSplitID, zr.ProcessedInLegacy
		FROM ZeroRecord zr
		INNER JOIN AccountTransactionSplit ats ON zr.ZeroRecordID = ats.ZeroRecordID
	)
	SELECT 
		a.AccountID, 
		a.AccountName, 
		qt.QIFType, 
		lr.ReferenceDate, 
		lr.LegacySpinelfinRef, 
		lr.Description AS Payee, 
		lr.Reconciled, 
		lr.Cleared, 
		lr.Amount, 
		ROW_NUMBER() OVER (PARTITION BY lr.AccountID, lr.LegacySpinelfinRef ORDER BY lr.TransactionSplitID) AS SplitNum,
		COUNT(lr.TransactionSplitID) OVER (PARTITION BY lr.AccountID, lr.LegacySpinelfinRef) AS SplitTotal, 
		ISNULL(c.Description, '') AS LegacyCategory, 
		ats.Description AS SplitDescription, 
		ats.Amount AS SplitAmount,
		lr.ProcessedInLegacy
	FROM cte_LegacyRecords lr
	INNER JOIN Account a ON lr.AccountID = a.AccountID
	INNER JOIN QIFType qt ON a.QIFTypeID = qt.QIFTypeID
	INNER JOIN AccountTransactionSplit ats ON lr.TransactionSplitID = ats.TransactionSplitID
	LEFT OUTER JOIN vCategory c ON ats.CategoryID = c.CategoryID


	/*
	select * From vLegacyEXport
	*/
GO

