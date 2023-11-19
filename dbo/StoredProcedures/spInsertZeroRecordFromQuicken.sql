CREATE PROCEDURE [dbo].[spInsertZeroRecordFromQuicken] 
	@AccountDescription nvarchar(50),
	@ReferenceDate date,
	@Notes nvarchar(max) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @AccountID int

    SELECT @AccountID = a.AccountID
	FROM Account a
	WHERE a.Description = @AccountDescription

	INSERT INTO ZeroRecord(AccountID, ReferenceDate, Notes, InQuicken)
	VALUES(@AccountID, @ReferenceDate, @Notes, 1)

	SELECT @@IDENTITY AS ZeroRecordID
END
GO

