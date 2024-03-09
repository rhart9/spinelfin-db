CREATE PROCEDURE [dbo].[spPopulateFromLegacyStaging]
AS
BEGIN
	;DISABLE TRIGGER AccountTransactionInsertUpdateTrigger ON AccountTransaction

	DECLARE @AccountTransactionMap AS TABLE(ImportedTransactionID int, TransactionID int)
	DECLARE @ZeroRecordMap AS TABLE(ImportedZeroRecordID int, ZeroRecordID int)

	EXEC spClearAllTransactions

	MERGE INTO AccountTransaction
	USING (
		SELECT 
			qst.ImportedTransactionID,
			a.AccountID, 
			NULL AS TransactionSerialNumber, 
			qst.TransactionDate, 
			qst.FriendlyDescription, 
			qst.Amount, 
			SUM(qst.Amount) OVER (PARTITION BY a.AccountID ORDER BY qst.TransactionDate, qst.ImportedTransactionID) AS Balance,
			qst.Reconciled, 
			qst.Cleared, 
			CASE WHEN ISNUMERIC(qst.LegacyCheckNumber) = 1 AND CAST(qst.LegacyCheckNumber AS int) BETWEEN 200 AND 6000 THEN qst.LegacyCheckNumber END AS CheckNumber, 
			qst.LegacyMemo, 
			qst.LegacyCheckNumber
		FROM LegacyStagingTransaction qst
		INNER JOIN Account a ON qst.AccountName = a.AccountName
	) src
	ON 1 = 0
	WHEN NOT MATCHED THEN
		INSERT (AccountID, TransactionSerialNumber, TransactionDate, FriendlyDescription, Amount, Balance, Reconciled, Cleared, CheckNumber, InLegacy, LegacyMemo, LegacyCheckNumber)
		VALUES (src.AccountID, src.TransactionSerialNumber, src.TransactionDate, src.FriendlyDescription, src.Amount, src.Balance, src.Reconciled, src.Cleared, src.CheckNumber, 1, src.LegacyMemo, src.LegacyCheckNumber)
	OUTPUT
		src.ImportedTransactionID, inserted.TransactionID INTO @AccountTransactionMap;

	MERGE INTO ZeroRecord
	USING (
		SELECT 
			qszr.ImportedZeroRecordID,
			a.AccountID,
			qszr.ReferenceDate
		FROM LegacyStagingZeroRecord qszr
		INNER JOIN Account a ON qszr.AccountName = a.AccountName
	) src
	ON 1 = 0
	WHEN NOT MATCHED THEN
		INSERT (AccountID, ReferenceDate, InLegacy)
		VALUES (src.AccountID, src.ReferenceDate, 1)
	OUTPUT
		src.ImportedZeroRecordID, inserted.ZeroRecordID INTO @ZeroRecordMap;

	INSERT INTO Category(CategoryTypeID, LegacyCategoryName)
	SELECT DISTINCT ct.CategoryTypeID, qsts.CategoryName
	FROM CategoryType ct,
		LegacyStagingTransactionSplit qsts
	WHERE ct.CategoryCode = 'U'
	AND NOT EXISTS (SELECT 1 FROM vCategory c WHERE c.Description = qsts.CategoryName)
	AND ISNULL(qsts.CategoryName, '') <> '' 
	AND NOT EXISTS (SELECT 1 FROM LegacyExcludeCategories WHERE CategoryName = qsts.CategoryName)
	AND NOT EXISTS (SELECT 1 FROM Account WHERE '[' + AccountName + ']' = qsts.CategoryName)

	INSERT INTO AccountTransactionSplit(TransactionID, ZeroRecordID, CategoryID, Amount, Description, ReferenceDate, LegacyCategory)
	SELECT tm.TransactionID, zm.ZeroRecordID, c.CategoryID, qsts.Amount, qsts.Description, qsts.ReferenceDate, qsts.CategoryName
	FROM LegacyStagingTransactionSplit qsts
	LEFT OUTER JOIN vCategory c ON qsts.CategoryName = c.Description
	LEFT OUTER JOIN @AccountTransactionMap tm ON qsts.ImportedTransactionID = tm.ImportedTransactionID
	LEFT OUTER JOIN @ZeroRecordMap zm ON qsts.ImportedZeroRecordID = zm.ImportedZeroRecordID

	;ENABLE TRIGGER AccountTransactionInsertUpdateTrigger ON AccountTransaction
END
GO

