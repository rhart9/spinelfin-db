-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[spExtendCategories] 
	-- Add the parameters for the stored procedure here
	@EndDate date = NULL
AS
BEGIN
	DECLARE @CurrentDate date, @LegacySwitchoverDate date, @CurrentMonth int, @CurrentYear int, @MonthID int, @WeekID int

	SELECT @LegacySwitchoverDate = MAX([Date]) FROM LegacySwitchoverDate

	SELECT @CurrentDate = DATEADD(d, 1, MAX(EndDate)) FROM CategoryMonth

	SELECT @CurrentDate = ISNULL(@CurrentDate, '4/5/2013')
	SELECT @EndDate = ISNULL(@EndDate, GETDATE())

	WHILE @CurrentDate < @EndDate
	BEGIN
		SELECT @CurrentYear = YEAR(@CurrentDate)
		SELECT @CurrentMonth = MONTH(@CurrentDate)

		INSERT INTO CategoryMonth(YearValue, MonthValue, StartDate)
		VALUES(@CurrentYear, @CurrentMonth, @CurrentDate)

		SELECT @MonthID = @@IDENTITY

		INSERT INTO Category(CategoryTypeID, MonthID)
		SELECT ct.CategoryTypeID, 
			@MonthID
		FROM CategoryType ct
		WHERE ct.CategoryCode IN ('I', 'ME')
		OR (@CurrentDate < @LegacySwitchoverDate AND ct.CategoryCode = 'D')

		WHILE @CurrentMonth = MONTH(@CurrentDate)
		BEGIN
			INSERT INTO CategoryWeek(MonthID, StartDate, EndDate)
			VALUES(@MonthID, @CurrentDate, DATEADD(d, 6, @CurrentDate))

			SELECT @WeekID = @@IDENTITY

			IF @CurrentDate >= @LegacySwitchoverDate
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
	END

END
GO

