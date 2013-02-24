
CREATE PROCEDURE [dbo].[SoftMedia_CleanAliases]
@AliasLevel INT
AS BEGIN
	UPDATE node
	SET node.NodeAliasPath = parent.NodeAliasPath + '/' + node.NodeAlias
	FROM CMS_Tree node
	INNER JOIN CMS_Tree parent
	ON node.NodeParentID = parent.NodeID
	WHERE node.NodeLevel = @AliasLevel
END
GO

DECLARE @index INT = 0
DECLARE @top INT
SELECT @top = MAX(NodeLevel) FROM CMS_Tree

WHILE (@index < @top)
BEGIN
	SET @index = @index + 1
	EXEC [dbo].[SoftMedia_CleanAliases] @AliasLevel = @index
END

--Cleanup stored proc
DROP PROCEDURE [dbo].[SoftMedia_CleanAliases]
GO

--Clean up double // from beginning of alias paths
UPDATE CMS_Tree set NodeAliasPath = REPLACE(NodeAliasPath, '//', '/')
GO