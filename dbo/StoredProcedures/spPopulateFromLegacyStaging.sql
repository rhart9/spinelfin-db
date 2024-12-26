CREATE PROCEDURE [dbo].[spPopulateFromLegacyStaging]
	@InitialLoad bit = 0
AS
BEGIN
	BEGIN TRAN

	DECLARE @AccountTransactionMap AS TABLE(ImportedTransactionID int, TransactionID int)
	DECLARE @ZeroRecordMap AS TABLE(ImportedZeroRecordID int, ZeroRecordID int)

	IF @InitialLoad = 1
	BEGIN
		EXEC spClearAllTransactions
	END
	ELSE
	BEGIN
		DELETE ats
		FROM AccountTransaction at
		INNER JOIN Account a ON at.AccountID = a.AccountID
		INNER JOIN AccountTransactionSplit ats ON at.TransactionID = ats.TransactionID
		LEFT OUTER JOIN LegacyStagingTransaction lst ON at.LegacySpinelfinRef = CAST(lst.LegacyRef AS int) AND a.AccountName = lst.AccountName
		WHERE lst.ImportedTransactionID IS NULL
		AND at.LegacySpinelfinRef IS NOT NULL
		AND at.Reconciled = 0

		DELETE at
		FROM AccountTransaction at
		INNER JOIN Account a ON at.AccountID = a.AccountID
		LEFT OUTER JOIN LegacyStagingTransaction lst ON at.LegacySpinelfinRef = CAST(lst.LegacyRef AS int) AND a.AccountName = lst.AccountName
		WHERE lst.ImportedTransactionID IS NULL
		AND at.LegacySpinelfinRef IS NOT NULL
		AND at.Reconciled = 0

		DELETE ats
		FROM ZeroRecord zr
		INNER JOIN Account a ON zr.AccountID = a.AccountID
		INNER JOIN AccountTransactionSplit ats ON zr.ZeroRecordID = ats.ZeroRecordID
		LEFT OUTER JOIN LegacyStagingZeroRecord lszr ON zr.LegacySpinelfinRef = CAST(lszr.LegacyRef AS int) AND a.AccountName = lszr.AccountName
		WHERE lszr.ImportedZeroRecordID IS NULL
		AND zr.LegacySpinelfinRef IS NOT NULL
		AND zr.Reconciled = 0

		DELETE zr
		FROM ZeroRecord zr
		INNER JOIN Account a ON zr.AccountID = a.AccountID
		LEFT OUTER JOIN LegacyStagingZeroRecord lszr ON zr.LegacySpinelfinRef = CAST(lszr.LegacyRef AS int) AND a.AccountName = lszr.AccountName
		WHERE lszr.ImportedZeroRecordID IS NULL
		AND zr.LegacySpinelfinRef IS NOT NULL
		AND zr.Reconciled = 0
	END
	MERGE INTO AccountTransaction at
	USING (
		SELECT 
			qst.ImportedTransactionID,
			a.AccountID, 
			NULL AS TransactionSerialNumber, 
			qst.TransactionDate, 
			qst.FriendlyDescription, 
			qst.Amount, 
			--SUM(qst.Amount) OVER (PARTITION BY a.AccountID ORDER BY qst.TransactionDate, qst.ImportedTransactionID) AS Balance,
			qst.Reconciled, 
			qst.Cleared, 
			CASE WHEN @InitialLoad = 1 THEN (CASE WHEN ISNUMERIC(qst.LegacyRef) = 1 AND CAST(qst.LegacyRef AS int) BETWEEN 200 AND 6000 THEN qst.LegacyRef END) END AS CheckNumber, 
			qst.LegacyMemo, 
			CASE WHEN @InitialLoad = 1 THEN qst.LegacyRef END AS LegacyCheckNumber,
			CASE WHEN @InitialLoad = 0 THEN CAST(qst.LegacyRef AS int) END AS LegacySpinelfinRef
		FROM LegacyStagingTransaction qst
		INNER JOIN Account a ON qst.AccountName = a.AccountName
	) src
	ON src.LegacySpinelfinRef = at.LegacySpinelfinRef AND src.AccountID = at.AccountID
	WHEN NOT MATCHED THEN
		INSERT (AccountID, TransactionSerialNumber, TransactionDate, FriendlyDescription, Amount, /*Balance,*/ Reconciled, Cleared, CheckNumber, LegacyMemo, LegacyCheckNumber, LegacySpinelfinRef, ProcessedInLegacy)
		VALUES (src.AccountID, src.TransactionSerialNumber, src.TransactionDate, src.FriendlyDescription, src.Amount, /*src.Balance,*/ src.Reconciled, src.Cleared, src.CheckNumber, src.LegacyMemo, src.LegacyCheckNumber, src.LegacySpinelfinRef, 1)
	WHEN MATCHED AND at.Reconciled = 0 THEN
		UPDATE SET TransactionDate = src.TransactionDate, FriendlyDescription = CASE WHEN at.CheckNumber IS NULL THEN src.FriendlyDescription ELSE at.FriendlyDescription END, Amount = src.Amount, Reconciled = src.Reconciled, Cleared = src.Cleared, ProcessedInLegacy = 1, UpdatedDT = getdate()
	OUTPUT
		src.ImportedTransactionID, inserted.TransactionID INTO @AccountTransactionMap;

	MERGE INTO ZeroRecord zr
	USING (
		SELECT 
			qszr.ImportedZeroRecordID,
			a.AccountID,
			qszr.ReferenceDate,
			qszr.Reconciled,
			CASE WHEN @InitialLoad = 0 THEN CAST(qszr.LegacyRef AS int) END AS LegacySpinelfinRef
		FROM LegacyStagingZeroRecord qszr
		INNER JOIN Account a ON qszr.AccountName = a.AccountName
	) src
	ON src.LegacySpinelfinRef = zr.LegacySpinelfinRef AND src.AccountID = zr.AccountID
	WHEN NOT MATCHED THEN
		INSERT (AccountID, ReferenceDate, Reconciled, LegacySpinelfinRef, ProcessedInLegacy)
		VALUES (src.AccountID, src.ReferenceDate, src.Reconciled, src.LegacySpinelfinRef, 1)
	WHEN MATCHED AND zr.Reconciled = 0 THEN
		UPDATE SET ReferenceDate = src.ReferenceDate, Reconciled = src.Reconciled, ProcessedInLegacy = 1, UpdatedDT = getdate()
	OUTPUT
		src.ImportedZeroRecordID, inserted.ZeroRecordID INTO @ZeroRecordMap;

	DECLARE @EndYear int, @EndMonth int

	SELECT @EndYear = MAX(CAST(SUBSTRING(qsts.CategoryName, 1, 4) as int))
	FROM LegacyStagingTransactionSplit qsts
	WHERE qsts.IsMonthlyCategory = 1

	SELECT @EndMonth = MAX(CAST(SUBSTRING(qsts.CategoryName, 6, 2) as int))
	FROM LegacyStagingTransactionSplit qsts
	WHERE qsts.IsMonthlyCategory = 1
	AND CAST(SUBSTRING(qsts.CategoryName, 1, 4) as int) = @EndYear

	EXEC spExtendCategories @EndYear, @EndMonth, 1

	INSERT INTO Category(CategoryTypeID, LegacyCategoryName)
	SELECT DISTINCT ct.CategoryTypeID, qsts.CategoryName
	FROM CategoryType ct,
		LegacyStagingTransactionSplit qsts
	WHERE ct.CategoryCode = 'U'
	AND NOT EXISTS (SELECT 1 FROM vCategory c WHERE c.Description = qsts.CategoryName)
	AND ISNULL(qsts.CategoryName, '') <> '' 
	AND NOT EXISTS (SELECT 1 FROM LegacyExcludeCategories WHERE CategoryName = qsts.CategoryName)
	AND NOT EXISTS (SELECT 1 FROM Account WHERE '[' + AccountName + ']' = qsts.CategoryName)

	DELETE ats 
	FROM AccountTransactionSplit ats
	INNER JOIN @AccountTransactionMap atm ON ats.TransactionID = atm.TransactionID

	DELETE ats
	FROM AccountTransactionSplit ats
	INNER JOIN @ZeroRecordMap zrm ON ats.ZeroRecordID = zrm.ZeroRecordID

	INSERT INTO AccountTransactionSplit(TransactionID, ZeroRecordID, CategoryID, Amount, Description, ReferenceDate, LegacyCategory)
	SELECT tm.TransactionID, zm.ZeroRecordID, c.CategoryID, qsts.Amount, qsts.Description, qsts.ReferenceDate, qsts.CategoryName
	FROM LegacyStagingTransactionSplit qsts
	LEFT OUTER JOIN vCategory c ON qsts.CategoryName = c.Description
	LEFT OUTER JOIN @AccountTransactionMap tm ON qsts.ImportedTransactionID = tm.ImportedTransactionID
	LEFT OUTER JOIN @ZeroRecordMap zm ON qsts.ImportedZeroRecordID = zm.ImportedZeroRecordID
	WHERE (tm.ImportedTransactionID IS NOT NULL OR zm.ImportedZeroRecordID IS NOT NULL)

	IF @InitialLoad = 1
	BEGIN
		EXEC spAssignLegacyRefs
	END

	COMMIT
END
GO

