/*
Rebuilds Kentico's node alias paths if the data has become out of
sync or corrupted.
*/
DECLARE @aliasLevel INT = 0
DECLARE @top INT
SELECT @top = MAX([NodeLevel]) FROM [CMS_Tree]

--Loop from root of tree to top
WHILE (@aliasLevel < @top)
BEGIN

    SET @aliasLevel = @aliasLevel + 1
    
    --Update alias path of nodes at this level
    UPDATE node
       SET node.[NodeAliasPath] = parent.[NodeAliasPath] + '/' + node.[NodeAlias]
      FROM [CMS_Tree] node
INNER JOIN [CMS_Tree] parent
        ON node.[NodeParentID] = parent.[NodeID]
     WHERE node.[NodeLevel] = @aliasLevel
    
END

--Clean up double // from beginning of alias paths
UPDATE [CMS_Tree] SET [NodeAliasPath] = REPLACE([NodeAliasPath], '//', '/')
GO