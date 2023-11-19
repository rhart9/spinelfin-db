CREATE PROCEDURE spExtendQuickenSwitchoverDate 
AS
BEGIN
	DECLARE @Now date = CAST(GETDATE() as date)

	UPDATE QuickenSwitchoverDate
	SET [Date] = DATEADD(m, 1, DATEADD(d, -1 * (DAY(@Now) - 1), @Now))
END
GO

