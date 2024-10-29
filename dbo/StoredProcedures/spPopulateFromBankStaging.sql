CREATE PROCEDURE [dbo].[spPopulateFromBankStaging]
	@BatchGUID uniqueidentifier,
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
			CASE WHEN t.Payee = '' THEN NULL ELSE t.Payee END AS Payee, 
			t.Amount,
			t.CheckNumber,
			pc.CheckDate,
			pc.Payee AS CheckPayee,
			ISNULL(pc.FriendlyDescription, pc.Payee) AS CheckFriendlyDescription
		FROM BankStagingTransaction t
		LEFT OUTER JOIN PendingCheck pc ON t.CheckNumber = pc.CheckNumber
		WHERE t.BatchGUID = @BatchGUID
	) src
	ON 1 = 0
	WHEN NOT MATCHED THEN
		INSERT (AccountID, TransactionDate, BankDescription, FriendlyDescription, Amount, ProcessedInLegacy, BankStagingTransactionID, ExportToLegacy, CheckNumberSequence, CheckNumber, CheckDate, CheckPayee)
		VALUES (src.AccountID, src.TransactionDate, src.Payee, CASE WHEN src.CheckNumber IS NOT NULL THEN src.CheckFriendlyDescription ELSE src.Payee END, src.Amount, 0, src.BankStagingTransactionID, @ExportToLegacy, CASE WHEN src.CheckNumber IS NOT NULL THEN @CheckNumberSequence END, src.CheckNumber, src.CheckDate, src.CheckPayee)
	OUTPUT
		inserted.TransactionID INTO @AccountTransactionMap;

	DELETE pc
	FROM PendingCheck pc
	INNER JOIN AccountTransaction at ON pc.CheckNumber = at.CheckNumber
	WHERE at.CheckNumberSequence = @CheckNumberSequence

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

