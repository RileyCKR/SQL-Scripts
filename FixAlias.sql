
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

DECLARE @index INT = 1
DECLARE @top INT
SELECT @top = MAX(NodeLevel) FROM CMS_Tree

--Clean aliases starting from the root and moving out
EXEC [dbo].[SoftMedia_CleanAliases] @AliasLevel = 1
GO
EXEC [dbo].[SoftMedia_CleanAliases] @AliasLevel = 2
GO
EXEC [dbo].[SoftMedia_CleanAliases] @AliasLevel = 3
GO
EXEC [dbo].[SoftMedia_CleanAliases] @AliasLevel = 4
GO
EXEC [dbo].[SoftMedia_CleanAliases] @AliasLevel = 5
GO
EXEC [dbo].[SoftMedia_CleanAliases] @AliasLevel = 6
GO

--Cleanup stored proc
DROP PROCEDURE [dbo].[SoftMedia_CleanAliases]
GO

--Clean up double // from beginning of alias paths
UPDATE CMS_Tree set NodeAliasPath = REPLACE(NodeAliasPath, '//', '/')
GO