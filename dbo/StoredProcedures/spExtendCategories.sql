-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[spExtendCategories] 
	@EndYear int = NULL,
	@EndMonth int = NULL,
	@UseLegacyConventions bit = 0
AS
BEGIN
	DECLARE @CurrentDate date, @CurrentMonth int, @CurrentYear int, @MonthID int, @WeekID int

	SELECT @CurrentDate = DATEADD(d, 1, MAX(EndDate)) FROM CategoryMonth

	SELECT @CurrentDate = ISNULL(@CurrentDate, '4/5/2013')
	SELECT @EndYear = ISNULL(@EndYear, YEAR(GETDATE()))
	SELECT @EndMonth = ISNULL(@EndMonth, MONTH(GETDATE()))

	SELECT @CurrentYear = YEAR(@CurrentDate)
	SELECT @CurrentMonth = MONTH(@CurrentDate)

	WHILE (@CurrentYear < @EndYear OR (@CurrentYear = @EndYear AND @CurrentMonth <= @EndMonth))
	BEGIN
		INSERT INTO CategoryMonth(YearValue, MonthValue, StartDate)
		VALUES(@CurrentYear, @CurrentMonth, @CurrentDate)

		SELECT @MonthID = @@IDENTITY

		INSERT INTO Category(CategoryTypeID, MonthID)
		SELECT ct.CategoryTypeID, 
			@MonthID
		FROM CategoryType ct
		WHERE ct.CategoryCode IN ('I', 'ME')
		OR (@UseLegacyConventions = 1 AND ct.CategoryCode = 'D')

		WHILE @CurrentMonth = MONTH(@CurrentDate)
		BEGIN
			INSERT INTO CategoryWeek(MonthID, StartDate, EndDate)
			VALUES(@MonthID, @CurrentDate, DATEADD(d, 6, @CurrentDate))

			SELECT @WeekID = @@IDENTITY

			IF @UseLegacyConventions = 0
			BEGIN
				INSERT INTO Category(CategoryTypeID, MonthID, WeekID)
				SELECT CategoryTypeID, @MonthID, @WeekID
				FROM CategoryType
				WHERE CategoryCode = 'D'
			END

			SELECT @CurrentDate = DATEADD(d, 7, @CurrentDate)
		END

		UPDATE CategoryMonth
		SET EndDate = DATEADD(d, -1, @CurrentDate)
		WHERE CategoryMonthID = @MonthID

		SELECT @CurrentYear = YEAR(@CurrentDate)
		SELECT @CurrentMonth = MONTH(@CurrentDate)
	END

END
GO

