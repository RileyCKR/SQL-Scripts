/*
Gets the size on disk of all user tables in the currently selected database. Useful
for tracking down the large tables in a bloated database.

Taken from marc_s at http://stackoverflow.com/a/7892349
*/
SELECT 
    t.[name] AS [TableName],
    p.[rows] AS [RowCounts],
    SUM(a.[total_pages]) * 8 AS TotalSpaceKB, 
    SUM(a.[used_pages]) * 8 AS UsedSpaceKB, 
    (SUM(a.[total_pages]) - SUM(a.[used_pages])) * 8 AS UnusedSpaceKB
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.[object_id] = i.[object_id]
INNER JOIN 
    sys.partitions p ON i.[object_id] = p.[object_id] AND i.[index_id] = p.[index_id]
INNER JOIN 
    sys.allocation_units a ON p.[partition_id] = a.[container_id]
WHERE 
    t.[name] NOT LIKE 'dt%' 
    AND t.[is_ms_shipped] = 0
    AND i.[object_id] > 255 
GROUP BY 
    t.[name], p.[rows]
ORDER BY 
    [TotalSpaceKB] DESC