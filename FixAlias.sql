
DECLARE @aliasLevel INT = 0
DECLARE @top INT
SELECT @top = MAX([NodeLevel]) FROM [CMS_Tree]

WHILE (@aliasLevel < @top)
BEGIN

    SET @aliasLevel = @aliasLevel + 1
    
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