BEGIN TRY
    BEGIN TRANSACTION

    -- place your SQL here

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION
    
    DECLARE @ErrorMessage NVARCHAR(MAX)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    
    SELECT @ErrorMessage = ERROR_MESSAGE() + ' (Line ' + CAST(ERROR_LINE() AS NVARCHAR(10)) + ')',
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();
           
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH