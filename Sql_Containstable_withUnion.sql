-- =============================================
-- Author:      Wendy M.
-- Create date: 1/2018
-- Description: Searches 2 tables for search term
-- Parameters:	@searchTerm, @format, @customerId
-- ReturnValue: FileDetail data set where items are found in 2 tables containing
--				the search term provided
-- =============================================
SELECT
	f.FileID
   ,f.Title
   ,f.FileName
   ,f.ImageUrl
   ,f.Duration
   ,f.Size
   ,f.customerID
   ,f.titleID
   ,f.Format
   ,f.ProxyUrl
   ,a.fileCount
   ,a.num
FROM FileDetail f
	,(SELECT
			 MAX(m.rank) rank
			,mt.FileID
			,ROW_NUMBER() OVER (ORDER BY FileID) num
			,COUNT(FileID) OVER () fileCount
		 FROM CONTAINSTABLE(MediaTag, (Tag), @searchTerm) m
			 ,MediaTag mt
		 WHERE mt.MediaTagID = m.[key]
		 GROUP BY mt.FileID

		 UNION

		 SELECT
			 m.rank
			,f.FileID
			,ROW_NUMBER() OVER (ORDER BY f.FileID) num
			,COUNT(f.FileID) OVER () fileCount
		 FROM CONTAINSTABLE(Metadata, (title,
			  Description,
			  Collection,
			  TitleID,
			  CarrierID,
			  ReferenceID,
			  CustomField), @searchTerm) m
			 ,FileDetail f
		 WHERE f.ProxyUrl IS NOT NULL
		 AND (f.MetadataID = m.[key])
		 AND f.ProxyFormat = @format) a
WHERE a.FileID = f.FileID
AND f.CustomerID = @customerId
AND f.ProxyFormat = @format
ORDER BY a.[rank] DESC;