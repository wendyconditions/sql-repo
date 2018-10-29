-- =============================================
-- Author:      Wendy M.
-- Create date: 9/2018
-- Description: Generates next title ID based off title count per customer.
--		If customer has 0 titles, then start from 1
-- Parameters:	@CustomerID: This will determine what the next ID available is for that customer.
-- ReturnValue: String TitleID - customer title count plus 1
-- =============================================
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
