DELETE FROM someTable
WHERE someAutoIncColumn > someValue

DBCC CHECKIDENT (someTable, RESEED, someValue)