DECLARE @DatabaseNameFilter VARCHAR(30)
DECLARE @TableNameFilter VARCHAR(30)

-- Set the following criteria
SET @DatabaseNameFilter = ''
SET @TableNameFilter = ''

DECLARE @SQL NVARCHAR(max)
 
SET @SQL = stuff((
            SELECT '
UNION
SELECT ' + quotename(NAME, '''') + ' as Db_Name, Name as Table_Name
FROM ' + quotename(NAME) + '.sys.tables WHERE NAME LIKE ''%'' + @TableName + ''%'''
            FROM sys.databases
			WHERE NAME LIKE '%' + @DatabaseNameFilter + '%'
            ORDER BY NAME
            FOR XML PATH('')
                ,type
            ).value('.', 'nvarchar(max)'), 1, 8, '')
 
EXECUTE sp_executeSQL @SQL
    ,N'@TableName varchar(30)'
    ,@TableName = @TableNameFilter