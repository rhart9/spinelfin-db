-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[spInsertTransactionSplitFromLegacy]
	@TransactionID int,
	@ZeroRecordID int,
	@CategoryName nvarchar(1024),
	@Amount decimal(9,2),
	@ReferenceDate date,
	@Description nvarchar(1024)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CategoryID int

	SELECT @CategoryID = c.CategoryID
	FROM vCategory c
	WHERE c.Description = @CategoryName

	IF @CategoryID IS NULL 
		AND ISNULL(@CategoryName, '') <> '' 
		AND NOT EXISTS (SELECT 1 FROM LegacyExcludeCategories WHERE CategoryName = @CategoryName)
		AND NOT EXISTS (SELECT 1 FROM Account WHERE '[' + AccountName + ']' = @CategoryName)
	BEGIN
		INSERT INTO Category(CategoryTypeID, LegacyCategoryName)
		SELECT ct.CategoryTypeID, @CategoryName
		FROM CategoryType ct
		WHERE ct.CategoryCode = 'U'

		SELECT @CategoryID = SCOPE_IDENTITY()
	END

	IF @TransactionID = 0
	BEGIN
		SELECT @TransactionID = NULL
	END

	IF @ZeroRecordID = 0
	BEGIN
		SELECT @ZeroRecordID = NULL
	END

	INSERT INTO AccountTransactionSplit(TransactionID, ZeroRecordID, CategoryID, Amount, Description, ReferenceDate, LegacyCategory)
	VALUES(@TransactionID, @ZeroRecordID, @CategoryID, @Amount, @Description, @ReferenceDate, @CategoryName)

	SELECT @@IDENTITY AS TransactionSplitID
END
GO

