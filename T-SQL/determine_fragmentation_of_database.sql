declare @database_name varchar(50)
set @database_name = 'mm718'

declare @database_id int
set @database_id = DB_ID(@database_name)	--NULL	--means all databases

declare @object_id int
set @object_id = NULL	--means all tables and views

declare @index_id int
set @index_id = NULL -- means all indexes

declare @partition_number int
set @partition_number = NULL	--means all partitions

declare @mode sysname
set @mode = NULL	--means limited scan level



SELECT OBJECT_NAME(T.object_id) AS tablename, I.name as indexname, IPS.* 
FROM sys.dm_db_index_physical_stats(@database_id, @object_id, @index_id, @partition_number, @mode) IPS
INNER JOIN sys.tables T WITH (nolock) ON IPS.object_id=T.object_id
INNER JOIN sys.indexes I WITH (nolock) ON IPS.object_id=I.object_id AND IPS.index_id=I.index_id
WHERE T.is_ms_shipped = 0
order by avg_fragmentation_in_percent desc
