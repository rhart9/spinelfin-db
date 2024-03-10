CREATE PROCEDURE spExtendLegacySwitchoverDate 
AS
BEGIN
	DECLARE @Now date = CAST(GETDATE() as date)

	UPDATE LegacySwitchoverDate
	SET [Date] = DATEADD(m, 1, DATEADD(d, -1 * (DAY(@Now) - 1), @Now))
END
GO

