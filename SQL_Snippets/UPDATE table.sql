
  
  
  
  UPDATE [ENTERTAINMENT].[dbo].[Datamart_Ringbacks]
SET Ringback_type ='New Valuepacks WITHOUT Ringbacks'
WHERE [closing base] = 82957


SELECT TOP 1000 [Index_No]
      ,[Ringback_Type]
      ,[Closing Base]
  FROM [ENTERTAINMENT].[dbo].[Datamart_Ringbacks]
  order by Index_No desc