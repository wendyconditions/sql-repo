ALTER FUNCTION [dbo].[AR_udf_GetNextTitleIDByCustomer](@CustomerID int)

RETURNS @Final TABLE(TitleID nvarchar(20))
AS
BEGIN
		If (select count(TitleID) from TableA WHERE CustomerID = @CustomerID) = 0
		BEGIN
			INSERT INTO @Final
				SELECT c.Abbr + '-' + '1'
				FROM TableB
				WHERE c.customerid = @CustomerID
		END
		ELSE
		BEGIN
			INSERT INTO @Final
				SELECT c.Abbr + '-' + CAST(COUNT(t.TitleID) + 1 AS NVARCHAR(20))
				FROM TableB c join
				TableA as t
				ON t.CustomerID = c.CustomerID
				WHERE c.customerid = @CustomerID
				GROUP BY c.Abbr
		END
		RETURN;
END;