

CREATE FUNCTION [dbo].[fnExpectedTransactionDate] 
(
	-- Add the parameters for the function here
	@MonthlyBudgetID int,
	@WeekNo int
)
RETURNS date
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result date

	;WITH cte_CategoryWeek AS (
		SELECT cw.MonthID, cw.StartDate, ROW_NUMBER() OVER (PARTITION BY cw.MonthID ORDER BY cw.StartDate) AS RowNum
		FROM CategoryWeek cw
	)
	SELECT @Result = 
		CASE ISNULL(mb.ReconFrequency, mb.AmountFrequency)
			WHEN 'M' THEN
				CASE WHEN mb.ScheduledDay > 0 THEN DATEADD(d, mb.ScheduledDay - 1, cm.FirstOfMonth) WHEN mb.ScheduledDay < 0 THEN DATEADD(d, mb.ScheduledDay, DATEADD(mm, 1, cm.FirstOfMonth)) END
			WHEN 'W' THEN
				DATEADD(d, mb.DayOffset, cw.StartDate)
		END
	FROM budget.MonthlyBudget mb
	INNER JOIN CategoryMonth cm ON mb.MonthID = cm.CategoryMonthID
	LEFT OUTER JOIN cte_CategoryWeek cw ON cm.CategoryMonthID = cw.MonthID AND cw.RowNum = @WeekNo
	WHERE mb.MonthlyBudgetID = @MonthlyBudgetID

	-- Return the result of the function
	RETURN @Result

END
GO

