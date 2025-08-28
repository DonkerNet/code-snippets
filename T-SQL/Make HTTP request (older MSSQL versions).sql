/*
	If Ole Automation Procedures are not allowed, run below once as an admin user.
*/
--sp_configure 'show advanced options', 1
--GO
--RECONFIGURE
--GO
--sp_configure 'Ole Automation Procedures', 1
--GO
--RECONFIGURE
--GO


/*
	Execute request
*/
DECLARE @Uri VARCHAR(2048)
SET @Uri = ''

DECLARE @HResult INT
DECLARE @ObjectToken INT
DECLARE @Success BIT
DECLARE @ErrorSource VARCHAR(255)
DECLARE @Result NVARCHAR(MAX)

-- Create the request
EXEC @HResult = sp_OACreate 'MSXML2.ServerXMLHttp', @ObjectToken OUT
IF @HResult <> 0
BEGIN
	SET @Result = 'sp_OACreate MSXML2.ServerXMLHttp failed'
	GOTO END_REQUEST
END

-- Configure the request to use the specified URI and HTTP method
EXEC @HResult = sp_OAMethod @ObjectToken, 'Open', NULL, 'POST', @Uri, false
IF @HResult <> 0
BEGIN
	SET @Result = 'sp_OAMethod Open failed'
	GOTO END_REQUEST
END

-- Add header
EXEC @HResult = sp_OAMethod @ObjectToken, 'setRequestHeader', NULL, 'X-Custom-Header', 'This is a test'
IF @HResult <> 0
BEGIN
	SET @Result = 'sp_OAMethod setRequestHeader failed'
	GOTO END_REQUEST
END

-- Send the request
EXEC @HResult = sp_OAMethod @ObjectToken, 'Send', NULL, ''
IF @HResult <> 0
BEGIN
	SET @Result = 'sp_OAMethod Send failed'
	GOTO END_REQUEST
END

-- Retrieve the response as text
EXEC @HResult = sp_OAGetProperty @ObjectToken, 'ResponseText', @Result OUTPUT
IF @HResult <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @ObjectToken, @ErrorSource OUTPUT, @Result OUTPUT
END

-- Finish the request by destroying the request object
END_REQUEST:
IF (@ObjectToken IS NOT NULL)
BEGIN
	EXEC @HResult = sp_OADestroy @ObjectToken
END

PRINT(@Result)
