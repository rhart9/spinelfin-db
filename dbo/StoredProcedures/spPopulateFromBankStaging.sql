CREATE PROCEDURE [dbo].[spPopulateFromBankStaging]
	@BatchGUID uniqueidentifier,
	@AutoPopulateFriendlyDescription bit,
	@ExportToLegacy bit = 0,
	@CheckNumberSequence int
AS
BEGIN
	BEGIN TRAN

	DECLARE @AccountTransactionMap AS TABLE(TransactionID int)

	MERGE INTO AccountTransaction
	USING (
		SELECT 
			t.BankStagingTransactionID,
			t.AccountID, 
			t.TransactionDate, 
			t.Payee, 
			t.Amount,
			t.CheckNumber
		FROM BankStagingTransaction t
		WHERE t.BatchGUID = @BatchGUID
	) src
	ON 1 = 0
	WHEN NOT MATCHED THEN
		INSERT (AccountID, TransactionDate, BankDescription, FriendlyDescription, Amount, ProcessedInLegacy, BankStagingTransactionID, ExportToLegacy, CheckNumberSequence, CheckNumber)
		VALUES (src.AccountID, src.TransactionDate, src.Payee, CASE WHEN @AutoPopulateFriendlyDescription = 1 THEN src.Payee ELSE NULL END, src.Amount, 0, src.BankStagingTransactionID, @ExportToLegacy, CASE WHEN src.CheckNumber IS NOT NULL THEN @CheckNumberSequence END, src.CheckNumber)
	OUTPUT
		inserted.TransactionID INTO @AccountTransactionMap;

	INSERT INTO AccountTransactionSplit(TransactionID, CategoryID, Amount, Description, ReferenceDate, LegacyCategory, Subcategory)
	SELECT at.TransactionID, c.CategoryID, at.Amount, bt.SplitDescription, at.TransactionDate, bt.CategoryName, bt.SubcategoryName
	FROM AccountTransaction at
	INNER JOIN @AccountTransactionMap tm ON at.TransactionID = tm.TransactionID
	INNER JOIN BankStagingTransaction bt ON at.BankStagingTransactionID = bt.BankStagingTransactionID
	LEFT OUTER JOIN vCategory c ON bt.CategoryName = c.Description

	EXEC spAssignLegacyRefs

	COMMIT
END
GO

