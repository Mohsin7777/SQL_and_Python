/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [INDEX_NO]
      ,[FRANCHISE]
      ,[BASE]
      ,[DEVICE_CLASS_DESC]
      ,[NETWORK_TYPE_DESC]
      ,[FEATURE_DESC]
      ,[MANF_DESC]
      ,[DEVICE_TYPE_DESC]
      ,[DEVICE_CATEGORY]
      ,[MODEL_ID]
      ,[TAC_DESC]
      ,[MODEL_DESC]
      ,[SUB_TYPE]
      ,[TAC]
  FROM [VOICE].[dbo].[RM_DEVICE_SUB]
  
  
  SELECT B.YEAR_DATE, B.MONTH_DATE,       [MANF_DESC]
      ,[DEVICE_TYPE_DESC]
      ,[MODEL_ID]
      ,BASE
  FROM [VOICE].[dbo].[RM_DEVICE_SUB] A
  INNER JOIN STAGE.dbo.STG_TIME_DIM_MONTHLY B
  ON A.INDEX_NO=B.INDEX_NO
  WHERE A.INDEX_NO = 44
  AND FRANCHISE = 'F'
  ORDER BY BASE DESC