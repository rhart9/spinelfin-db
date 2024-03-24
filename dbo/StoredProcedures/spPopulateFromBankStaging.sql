CREATE PROCEDURE [dbo].[spPopulateFromBankStaging]
	@BatchGUID uniqueidentifier,
	@AutoPopulateFriendlyDescription bit
AS
BEGIN
	;DISABLE TRIGGER AccountTransactionInsertUpdateTrigger ON AccountTransaction

	DECLARE @AccountTransactionMap AS TABLE(TransactionID int)

	MERGE INTO AccountTransaction
	USING (
		SELECT 
			t.BankStagingTransactionID,
			t.AccountID, 
			t.TransactionDate, 
			t.Payee, 
			t.Amount
		FROM BankStagingTransaction t
		WHERE t.BatchGUID = @BatchGUID
	) src
	ON 1 = 0
	WHEN NOT MATCHED THEN
		INSERT (AccountID, TransactionDate, BankDescription, FriendlyDescription, Amount, ProcessedInLegacy, BankStagingTransactionID)
		VALUES (src.AccountID, src.TransactionDate, src.Payee, CASE WHEN @AutoPopulateFriendlyDescription = 1 THEN src.Payee ELSE NULL END, src.Amount, 0, src.BankStagingTransactionID)
	OUTPUT
		inserted.TransactionID INTO @AccountTransactionMap;

	INSERT INTO AccountTransactionSplit(TransactionID, Amount, ReferenceDate)
	SELECT at.TransactionID, at.Amount, at.TransactionDate
	FROM AccountTransaction at
	INNER JOIN @AccountTransactionMap tm ON at.TransactionID = tm.TransactionID

	EXEC spAssignLegacyRefs

	;ENABLE TRIGGER AccountTransactionInsertUpdateTrigger ON AccountTransaction
END
GO

