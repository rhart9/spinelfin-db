

CREATE FUNCTION fnExpectedTransactionDate 
(
	-- Add the parameters for the function here
	@MonthlyBudgetID int
)
RETURNS date
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result date

	SELECT @Result = CASE WHEN mb.ScheduledDay > 0 THEN DATEADD(d, mb.ScheduledDay - 1, cm.FirstOfMonth) WHEN mb.ScheduledDay < 0 THEN DATEADD(d, mb.ScheduledDay, DATEADD(mm, 1, cm.FirstOfMonth)) END
	FROM budget.MonthlyBudget mb
	INNER JOIN CategoryMonth cm ON mb.MonthID = cm.CategoryMonthID
	WHERE mb.MonthlyBudgetID = @MonthlyBudgetID

	-- Return the result of the function
	RETURN @Result

END
GO

