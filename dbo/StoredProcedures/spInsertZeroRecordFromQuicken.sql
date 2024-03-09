CREATE PROCEDURE [dbo].[spInsertZeroRecordFromLegacy] 
	@AccountName nvarchar(50),
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
	WHERE a.AccountName = @AccountName

	INSERT INTO ZeroRecord(AccountID, ReferenceDate, Notes, InLegacy)
	VALUES(@AccountID, @ReferenceDate, @Notes, 1)

	SELECT @@IDENTITY AS ZeroRecordID
END
GO

