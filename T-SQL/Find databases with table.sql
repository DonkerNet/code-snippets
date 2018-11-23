DECLARE @DatabaseNameFilter VARCHAR(30)
DECLARE @SchemaNameFilter VARCHAR(30)
DECLARE @TableNameFilter VARCHAR(30)

-- Set the following criteria
SET @DatabaseNameFilter = ''
SET @SchemaNameFilter = ''
SET @TableNameFilter = ''

DECLARE @SQL NVARCHAR(max)
 
SET @SQL = stuff((
            SELECT '
UNION
SELECT ' + quotename(NAME, '''') + ' as Db_Name, S.Name AS Schema_Name, T.Name as Table_Name
FROM ' + quotename(NAME) + '.sys.tables AS T
JOIN sys.schemas AS S
ON S.schema_id = T.schema_id
WHERE S.name LIKE ''%'' + @SchemaName + ''%''
AND T.Name LIKE ''%'' + @TableName + ''%'''
            FROM sys.databases
			WHERE NAME LIKE '%' + @DatabaseNameFilter + '%'
            ORDER BY NAME
            FOR XML PATH('')
                ,type
            ).value('.', 'nvarchar(max)'), 1, 8, '')
 
EXECUTE sp_executeSQL @SQL
    ,N'@TableName varchar(30), @SchemaName varchar(30)'
	,@TableName = @TableNameFilter
	,@SchemaName = @SchemaNameFilter