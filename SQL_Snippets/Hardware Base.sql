/****** Script for SelectTopNRows command from SSMS  ******/

---- mart needs Windows 7 phones


SELECT distinct(DEVICE_category)
, DEVICE_TYPE_DESC
, DEVICE_CLASS_DESC
, SUB_TYPE 
,  SUM(base) as 'base'
  FROM [VOICE].[dbo].[RM_DEVICE_SUB]
  where INDEX_NO = '38' 
and FRANCHISE = 'r' 
  group by DEVICE_category
, DEVICE_TYPE_DESC
, DEVICE_CLASS_DESC
, SUB_TYPE

 
select * from [VOICE].[dbo].[RM_DEVICE_SUB]


---- SUB_TYPE = 'V4d' is data only devices


---- sanity check:

select SUM(base)
from [VOICE].[dbo].[RM_DEVICE_SUB]
where INDEX_NO = '38' 

and device_category = 'machine'
(4K)