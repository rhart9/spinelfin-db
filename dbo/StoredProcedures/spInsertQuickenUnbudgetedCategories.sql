-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[spInsertLegacyUnbudgetedCategories] 
	-- Add the parameters for the stored procedure here
	@NumACategories int = 0, 
	@NumBCategories int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @UnbudgetedCategoryTypeID int, @cnt int

	SELECT @UnbudgetedCategoryTypeID = ct.CategoryTypeID FROM CategoryType ct WHERE ct.CategoryCode = 'U'

	SELECT @cnt = 1
	WHILE @cnt <= @NumACategories
	BEGIN
		INSERT INTO Category(CategoryTypeID, LegacyCategoryName)
		VALUES(@UnbudgetedCategoryTypeID, 'A' + RIGHT('00' + CAST(@cnt AS nvarchar), 2))

		SELECT @cnt = @cnt + 1
	END

	SELECT @cnt = 1
	WHILE @cnt <= @NumBCategories
	BEGIN
		INSERT INTO Category(CategoryTypeID, LegacyCategoryName)
		VALUES(@UnbudgetedCategoryTypeID, 'B' + RIGHT('00' + CAST(@cnt AS nvarchar), 2))

		SELECT @cnt = @cnt + 1
	END

	INSERT INTO Category(CategoryTypeID, LegacyCategoryName)
	VALUES(@UnbudgetedCategoryTypeID, 'C01')

	INSERT INTO Category(CategoryTypeID, LegacyCategoryName)
	VALUES(@UnbudgetedCategoryTypeID, 'D01')

	INSERT INTO Category(CategoryTypeID, LegacyCategoryName)
	VALUES(@UnbudgetedCategoryTypeID, 'E01')

	INSERT INTO Category(CategoryTypeID, LegacyCategoryName)
	VALUES(@UnbudgetedCategoryTypeID, 'F01')
END
GO

