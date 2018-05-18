SELECT *
FROM (
	SELECT
		DB_NAME(MF.database_id) AS DatabaseName,
		MF.name AS LogicalFileName,
		MF.physical_name AS PhysicalFileName 
	FROM sys.master_files AS MF
) AS DT
ORDER BY DT.DataBaseName