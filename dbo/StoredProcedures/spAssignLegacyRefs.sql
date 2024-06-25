CREATE PROCEDURE [dbo].[spAssignLegacyRefs]
AS
BEGIN
	;WITH cte_LegacyRecords AS (
		SELECT 'AccountTransaction' AS SourceTable, at.TransactionID AS ID, at.AccountID, at.TransactionDate AS ReferenceDate, at.LegacySpinelfinRef, at.ExportToLegacy FROM AccountTransaction at
		UNION
		SELECT 'ZeroRecord' AS SourceTable, zr.ZeroRecordID AS ID, zr.AccountID, zr.ReferenceDate, zr.LegacySpinelfinRef, zr.ExportToLegacy FROM ZeroRecord zr
	)
	SELECT *
	INTO #LegacyRecords
	FROM cte_LegacyRecords
	WHERE (ExportToLegacy = 1 OR LegacySpinelfinRef IS NOT NULL)

	;WITH cte_MaxLegacyRefs AS (
		SELECT lr.AccountID, MAX(lr.LegacySpinelfinRef) AS MaxRef
		FROM #LegacyRecords lr
		GROUP BY lr.AccountID
	),
	cte_NumberedLegacyRecords AS (
		SELECT lr.SourceTable, lr.ID, ISNULL(cmlr.MaxRef, 0) + ROW_NUMBER() OVER (PARTITION BY lr.AccountID ORDER BY lr.ReferenceDate, CASE WHEN lr.SourceTable = 'ZeroRecord' THEN 1 ELSE 2 END, lr.ID) AS LegacyRef
		FROM #LegacyRecords lr
		INNER JOIN cte_MaxLegacyRefs cmlr ON lr.AccountID = cmlr.AccountID
		WHERE lr.LegacySpinelfinRef IS NULL
	)
	UPDATE lr
	SET lr.LegacySpinelfinRef = cnlr.LegacyRef
	FROM #LegacyRecords lr
	INNER JOIN cte_NumberedLegacyRecords cnlr ON lr.SourceTable = cnlr.SourceTable AND lr.ID = cnlr.ID

	UPDATE at
	SET at.LegacySpinelfinRef = lr.LegacySpinelfinRef
	FROM AccountTransaction at
	INNER JOIN #LegacyRecords lr ON at.TransactionID = lr.ID AND lr.SourceTable = 'AccountTransaction'
	WHERE at.LegacySpinelfinRef IS NULL

	UPDATE zr
	SET zr.LegacySpinelfinRef = lr.LegacySpinelfinRef
	FROM ZeroRecord zr
	INNER JOIN #LegacyRecords lr ON zr.ZeroRecordID = lr.ID AND lr.SourceTable = 'ZeroRecord'
	WHERE zr.LegacySpinelfinRef IS NULL
END
GO

