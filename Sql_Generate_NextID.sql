-- =============================================
-- Author:      Wendy M.
-- Create date: 9/2018
-- Description: Generates next title ID based off title count per customer.
--		If customer has 0 titles, then start from 1
-- Parameters:	@CustomerID: This will determine what the next ID available is for that customer.
-- ReturnValue: String TitleID - customer title count plus 1
-- =============================================
ALTER FUNCTION [dbo].[AR_udf_NextTileIDbyCustomerID](
                @customerID int)
RETURNS nvarchar(20)
AS
BEGIN
    DECLARE @titleID nvarchar(20);

    SELECT @titleID = c.Abbr+'-'+CAST(
                                      (
                                       SELECT COUNT(titleID)
                                         FROM AR_Title
                                         WHERE CustomerID = @customerID
                                      ) + 1 AS nvarchar(20))
      FROM drms.dbo.Customer c
      WHERE c.CustomerID = @customerID;

    RETURN @titleID;
END;
