
  
DECLARE @1 VARCHAR(1)

SET @1 = '1'

SELECT distinct
LEFT(@1 + REPLICATE(CAST(IMEI_CUR AS VARCHAR),15) ,15) AS IMEI_WITH_1_ADDED
FROM   [ENTERTAINMENT].[dbo].[TEST_HPG_ACTS]
order by IMEI_WITH_1_ADDED 
  
  

SELECT DISTINCT IMEI_CUR
FROM [ENTERTAINMENT].[dbo].[TEST_HPG_ACTS]