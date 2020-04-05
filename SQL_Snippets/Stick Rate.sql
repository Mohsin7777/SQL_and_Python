




--------------------------- PART 1: GRAB TRUE ADDS (SCRUBBING OUT ACCOUNT CHANGES AND MIGRATIONS FROM GROSS ADDS)
--------------------------- SEE HOW MANY SUBS AT THE START OF THE PERIOD (90/120 ETC.) REMAIN AT THE END



--  -------- TEMP SERVICE
--  SELECT BAN, SUBSCRIBER_NO, EFFECTIVE_DATE, EXPIRATION_DATE, SOC
--  INTO #SERVICE_URMUSIC
--  FROM STAGE.dbo.STG_SERVICE_AGREEMENT 
--  WHERE SOC IN (
--  'MS2GOWBR',
--'MSPCR',
--'OPTSRA0WS',
--'OPTSRA0WT',
--'OPTSRA0WU'
--)
  
  
  
  

--DECLARE @INDEX AS NUMERIC(4,0)
--DECLARE @START AS DATETIME
--DECLARE @END AS DATETIME

--set @INDEX = (select MAX (INDEX_NO)        ------------------- TAKE AWAY (-#) FOR LAST WEEK
--from [STAGE].[dbo].[STG_TIME_DIM_MONTHLY]
--where [EOM] +.9999999 <= GETDATE())

--SET @START = (SELECT DISTINCT SOM 
--FROM [STAGE].[dbo].[STG_TIME_DIM_MONTHLY]
--WHERE INDEX_NO = @INDEX)

--SET @END = (SELECT DISTINCT EOM
--FROM [STAGE].[dbo].[STG_TIME_DIM_MONTHLY]
--WHERE INDEX_NO = @INDEX) 

----SELECT @INDEX
----SELECT @START
----SELECT @END




----SELECT A.*, 
----	CASE 
----		WHEN (EFFECTIVE_DATE >= @START AND EFFECTIVE_DATE <= @END)
----		THEN 1
----		ELSE 0
----		END AS "GROSS_ADDS",
----	CASE 
----		WHEN (EXPIRATION_DATE >= @START AND EXPIRATION_DATE <= @END)
----		THEN 1
----		ELSE 0
----		END AS "DEACTS",
----	CASE 
----		WHEN (EXPIRATION_DATE IS NULL OR EXPIRATION_DATE > @END) 
----		AND EFFECTIVE_DATE <= @END
----		THEN 1
----		ELSE 0
----		END AS "CLOSE",
----	CASE 
----		WHEN EFFECTIVE_DATE < @START 
----		AND (EXPIRATION_DATE >= @START OR EXPIRATION_DATE IS NULL)
----		THEN 1
----		ELSE 0
----		END AS "OPEN"
----INTO #TOTAL_URMUSIC_METRICS 
----FROM #SERVICE_URMUSIC A


---- ------------------TEMP SUB HOLDS ALL ACCOUNT CHANGES FOR THE DESIRED PERIOD (WEEK)
--SELECT CUSTOMER_BAN, 
--	SUBSCRIBER_NO, 
--	EARLIEST_ACTV_DATE,
--	PRV_BAN, 
--	PRV_BAN_MOVE_DATE, 
--	PRV_CTN, 
--	PRV_CTN_CHG_DATE,
--	NEXT_BAN,
--	NEXT_BAN_MOVE_DATE,
--	NEXT_CTN,
--	NEXT_CTN_CHG_DATE,
--	SUB_STATUS
--INTO #SUB_TEMP
--FROM STAGE.dbo.STG_SUBSCRIBER
--WHERE (PRV_BAN_MOVE_DATE >= @START AND PRV_BAN_MOVE_DATE <= @END)
--OR (PRV_CTN_CHG_DATE >= @START AND PRV_CTN_CHG_DATE <= @END)
--OR (NEXT_BAN_MOVE_DATE >= @START AND NEXT_BAN_MOVE_DATE <= @END)
--OR (NEXT_CTN_CHG_DATE >= @START AND NEXT_CTN_CHG_DATE <= @END)
--AND PRODUCT_TYPE = 'C'

 
---------SCRUB SERVICE AGREEMENT FOR ANNOMALIES (CASES WHERE EFF_DATE IN SERVICE IS LESS THAN THE TIME THE ACCOUNT WAS CREATED (ACCORDING TO SUB_TEMP))

--CREATE TABLE #MASTER_SUB(
--	BAN NUMERIC(9,0),
--	CTN VARCHAR(20),
--	COMPARE_DATE DATE)
--INSERT INTO #MASTER_SUB(
--	BAN,
--	CTN,
--	COMPARE_DATE)
--SELECT DISTINCT CUSTOMER_BAN, SUBSCRIBER_NO, EARLIEST_ACTV_DATE
--FROM #SUB_TEMP

--INSERT INTO #MASTER_SUB(
--	BAN,
--	CTN,
--	COMPARE_DATE)
--SELECT DISTINCT NEXT_BAN, SUBSCRIBER_NO, NEXT_BAN_MOVE_DATE
--FROM #SUB_TEMP
--WHERE NEXT_BAN_MOVE_DATE IS NOT NULL

--INSERT INTO #MASTER_SUB(
--	BAN,
--	CTN,
--	COMPARE_DATE)
--SELECT DISTINCT CUSTOMER_BAN, NEXT_CTN, NEXT_CTN_CHG_DATE
--FROM #SUB_TEMP
--WHERE NEXT_CTN_CHG_DATE IS NOT NULL

--SELECT distinct T.*
--INTO #DELETE
--FROM #TOTAL_URMUSIC_METRICS T
--INNER JOIN #MASTER_SUB S
--	ON S.BAN = T.BAN AND S.CTN = T.SUBSCRIBER_NO
--WHERE COMPARE_DATE > T.EFFECTIVE_DATE



------------------------ JOIN ON EVERYTHING (INCLUDING EXPIRATION_DATE) TO SCRUB OUT RECORDS WHERE EFF_EXP DOESNT MAKE SENSE

--SELECT T.*
--INTO #TOTAL_URMUSIC_METRICS1
--FROM #TOTAL_URMUSIC_METRICS T
--LEFT OUTER JOIN #DELETE D
--	ON T.BAN = D.BAN AND T.SUBSCRIBER_NO = D.SUBSCRIBER_NO AND T.SOC = D.SOC AND T.EFFECTIVE_DATE = D.EFFECTIVE_DATE AND T.EXPIRATION_DATE = D.EXPIRATION_DATE
--WHERE D.BAN IS NULL AND D.SUBSCRIBER_NO IS NULL AND D.SOC IS NULL AND D.EFFECTIVE_DATE IS NULL





---- ADDS DUE TO BAN CHANGES

--SELECT A.SUBSCRIBER_NO
--	,B.CUSTOMER_BAN
--	,A.SOC
--	,A.EFFECTIVE_DATE
--	,A.EXPIRATION_DATE
--	,B.NEXT_BAN
--into #BANchange
--FROM #TOTAL_URMUSIC_METRICS1 a
--INNER JOIN #SUB_TEMP b
--	ON a.BAN = b.next_ban AND a.SUBSCRIBER_NO = b.SUBSCRIBER_NO and a.EFFECTIVE_DATE = b.NEXT_BAN_MOVE_DATE
--WHERE GROSS_ADDS = 1

--SELECT B.NEXT_BAN AS "BAN", B.SUBSCRIBER_NO, B.SOC, B.EFFECTIVE_DATE, B.EXPIRATION_DATE
--INTO #NONTRUEADDS
--FROM #BANCHANGE B
--INNER JOIN #TOTAL_URMUSIC_METRICS1 V
--	ON B.CUSTOMER_BAN = V.BAN AND B.SUBSCRIBER_NO = V.SUBSCRIBER_NO AND B.SOC = V.SOC AND B.EFFECTIVE_DATE = V.EXPIRATION_DATE
--INNER JOIN #SUB_TEMP S
--	ON B.CUSTOMER_BAN = S.CUSTOMER_BAN AND B.SUBSCRIBER_NO = S.SUBSCRIBER_NO
--WHERE S.SUB_STATUS = 'C'

------ ADDS DUE TO CTN CHANGES

--SELECT B.SUBSCRIBER_NO
--	,A.BAN
--	,A.SOC
--	,A.EFFECTIVE_DATE
--	,A.EXPIRATION_DATE
--	,B.NEXT_CTN
--into #CTNchange
--FROM #TOTAL_URMUSIC_METRICS1 a
--INNER JOIN #SUB_TEMP b
--	ON a.BAN = b.customer_BAN AND a.SUBSCRIBER_NO = b.NEXT_CTN and a.EFFECTIVE_DATE = b.NEXT_CTN_CHG_DATE
--WHERE GROSS_ADDS = 1

--INSERT INTO #NONTRUEADDS(
--	BAN,
--	SUBSCRIBER_NO, 
--	SOC,
--	EFFECTIVE_DATE,
--	EXPIRATION_DATE)
--SELECT B.BAN, B.NEXT_CTN, B.SOC, B.EFFECTIVE_DATE, B.EXPIRATION_DATE
--FROM #CTNCHANGE B
--INNER JOIN #TOTAL_URMUSIC_METRICS1 V
--	ON B.BAN = V.BAN AND B.SUBSCRIBER_NO = V.SUBSCRIBER_NO AND B.SOC = V.SOC AND B.EFFECTIVE_DATE = V.EXPIRATION_DATE
--INNER JOIN #SUB_TEMP S
--	ON B.BAN = S.CUSTOMER_BAN AND B.SUBSCRIBER_NO = S.SUBSCRIBER_NO
--WHERE S.SUB_STATUS = 'C'


----- ADDS DUE TO BAN AND CTN CHANGES
 
--SELECT B.SUBSCRIBER_NO
--	,B.CUSTOMER_BAN
--	,A.SOC
--	,A.EFFECTIVE_DATE
--	,A.EXPIRATION_DATE
--	,B.NEXT_CTN
--	,B.NEXT_BAN
--into #BANCTNchange
--FROM #TOTAL_URMUSIC_METRICS1 a
--INNER JOIN #SUB_TEMP b
--	ON a.BAN = b.NEXT_BAN AND a.SUBSCRIBER_NO = b.NEXT_CTN and a.EFFECTIVE_DATE = b.NEXT_CTN_CHG_DATE AND A.EFFECTIVE_DATE = B.NEXT_BAN_MOVE_DATE
--WHERE GROSS_ADDS = 1

--INSERT INTO #NONTRUEADDS(
--	BAN,
--	SUBSCRIBER_NO, 
--	SOC,
--	EFFECTIVE_DATE,
--	EXPIRATION_DATE)
--SELECT B.NEXT_BAN, B.NEXT_CTN, B.SOC, B.EFFECTIVE_DATE, B.EXPIRATION_DATE
--FROM #BANCTNCHANGE B
--INNER JOIN #TOTAL_VP_METRICS1 V
--	ON B.CUSTOMER_BAN = V.BAN AND B.SUBSCRIBER_NO = V.SUBSCRIBER_NO AND B.SOC = V.SOC AND B.EFFECTIVE_DATE = V.EXPIRATION_DATE
--INNER JOIN #SUB_TEMP S
--	ON B.CUSTOMER_BAN = S.CUSTOMER_BAN AND B.SUBSCRIBER_NO = S.SUBSCRIBER_NO
--WHERE S.SUB_STATUS = 'C'

--SELECT V.*, 
--	CASE 
--		WHEN N.BAN IS NOT NULL AND N.SUBSCRIBER_NO IS NOT NULL AND N.SOC IS NOT NULL 
--		THEN 1 
--		ELSE 0 END AS "NONTRUEADD"
--INTO #TOTAL_URMUSIC_METRICS1_WNTA
--FROM #TOTAL_URMUSIC_METRICS1 V
--LEFT OUTER JOIN #NONTRUEADDS N
--	ON V.BAN = N.BAN AND V.SUBSCRIBER_NO = N.SUBSCRIBER_NO AND V.SOC = N.SOC AND V.EFFECTIVE_DATE = N.EFFECTIVE_DATE



---- DEACTS DUE TO BAN CHANGES

--SELECT A.SUBSCRIBER_NO
--	,A.BAN
--	,A.SOC
--	,A.EFFECTIVE_DATE
--	,A.EXPIRATION_DATE
--	,B.NEXT_BAN
--into #DEACTBANchange
--FROM #TOTAL_URMUSIC_METRICS1 a
--INNER JOIN #SUB_TEMP b
--	ON a.BAN = b.customer_BAN AND a.SUBSCRIBER_NO = b.SUBSCRIBER_NO and a.EXPIRATION_DATE = b.NEXT_BAN_MOVE_DATE
--WHERE DEACTS = 1
--AND SUB_STATUS = 'C'

--SELECT B.BAN, B.SUBSCRIBER_NO, B.SOC, B.EFFECTIVE_DATE, B.EXPIRATION_DATE
--INTO #NONTRUEDEACTS
--FROM #DEACTBANCHANGE B
--INNER JOIN #TOTAL_URMUSIC_METRICS1 V
--	ON B.NEXT_BAN = V.BAN AND B.SUBSCRIBER_NO = V.SUBSCRIBER_NO AND B.SOC = V.SOC AND B.EXPIRATION_DATE = V.EFFECTIVE_DATE


-------- DEACTS DUE TO CTN CHANGES

--SELECT A.SUBSCRIBER_NO
--	,A.BAN
--	,A.SOC
--	,A.EFFECTIVE_DATE
--	,A.EXPIRATION_DATE
--	,B.NEXT_CTN
--into #DEACTCTNchange
--FROM #TOTAL_URMUSIC_METRICS1 a
--INNER JOIN #SUB_TEMP b
--	ON a.BAN = b.customer_BAN AND a.SUBSCRIBER_NO = b.SUBSCRIBER_NO and a.EXPIRATION_DATE = b.NEXT_CTN_CHG_DATE
--WHERE DEACTS = 1
--AND SUB_STATUS = 'C'

--INSERT INTO #NONTRUEDEACTS(
--	BAN,
--	SUBSCRIBER_NO, 
--	SOC,
--	EFFECTIVE_DATE,
--	EXPIRATION_DATE)
--SELECT B.BAN, B.SUBSCRIBER_NO, B.SOC, B.EFFECTIVE_DATE, B.EXPIRATION_DATE
--FROM #DEACTCTNCHANGE B
--INNER JOIN #TOTAL_URMUSIC_METRICS1 V
--	ON B.BAN = V.BAN AND B.NEXT_CTN = V.SUBSCRIBER_NO AND B.SOC = V.SOC AND B.EXPIRATION_DATE = V.EFFECTIVE_DATE



------- DEACTS DUE TO BAN AND CTN CHANGES
 
--SELECT A.SUBSCRIBER_NO
--	,A.BAN
--	,A.SOC
--	,A.EFFECTIVE_DATE
--	,A.EXPIRATION_DATE
--	,B.NEXT_CTN
--	,B.NEXT_BAN
--into #DEACTBANCTNchange
--FROM #TOTAL_URMUSIC_METRICS1 a
--INNER JOIN #SUB_TEMP b
--	ON a.BAN = b.customer_BAN AND a.SUBSCRIBER_NO = b.SUBSCRIBER_NO and a.EXPIRATION_DATE = b.NEXT_CTN_CHG_DATE AND A.EXPIRATION_DATE = B.NEXT_BAN_MOVE_DATE
--WHERE DEACTS = 1
--AND SUB_STATUS = 'C'


--INSERT INTO #NONTRUEDEACTS(
--	BAN,
--	SUBSCRIBER_NO, 
--	SOC,
--	EFFECTIVE_DATE,
--	EXPIRATION_DATE)
--SELECT B.BAN, B.SUBSCRIBER_NO, B.SOC, B.EFFECTIVE_DATE, B.EXPIRATION_DATE
--FROM #DEACTBANCTNCHANGE B
--INNER JOIN #TOTAL_URMUSIC_METRICS1 V
--	ON B.NEXT_BAN = V.BAN AND B.NEXT_CTN = V.SUBSCRIBER_NO AND B.SOC = V.SOC AND B.EXPIRATION_DATE = V.EFFECTIVE_DATE


--SELECT V.*, 
--	CASE 
--		WHEN N.BAN IS NOT NULL AND N.SUBSCRIBER_NO IS NOT NULL AND N.SOC IS NOT NULL 
--		THEN 1 
--		ELSE 0 END AS "NONTRUEDEACT"
--INTO #URMUSIC_METRICS
--FROM #TOTAL_URMUSIC_METRICS1_WNTA V
--LEFT OUTER JOIN #NONTRUEDEACTS N
--	ON V.BAN = N.BAN AND V.SUBSCRIBER_NO = N.SUBSCRIBER_NO AND V.SOC = N.SOC AND V.EXPIRATION_DATE = N.EXPIRATION_DATE



----------------------------------------------------- 









------------------------------- MIGRATIONS FOR GROSS ADDS/DEACTS (FILTER NONTRUEADDS AND NONTRUEDEACTS)
------------------------------ 1: VP-TO-VP   


SELECT BAN, SUBSCRIBER_NO, SOC, EFFECTIVE_DATE, EXPIRATION_DATE, GROSS_ADDS, DEACTS
INTO #VP_MIGRATIONS_ONLY_1
FROM #METRICS_1
WHERE NONTRUEADD=0
AND NONTRUEDEACT=0
AND SOC_TYPE='VALUEPACK'
AND (GROSS_ADDS=1 OR DEACTS = 1)

SELECT *
INTO #GROSS_ADDS
FROM #VP_MIGRATIONS_ONLY_1 
where GROSS_ADDS = 1

SELECT *
INTO #DEACTS
FROM #FINAL_VP_METRICS 
WHERE  DEACTS = 1

------------------------------- ADDS DUE TO MIGRATIONS


SELECT A.*
INTO #GROSS_ADDS_MIGRATIONS
FROM #GROSS_ADDS A
INNER JOIN #DEACTS B
ON A.BAN=B.BAN
AND A.SUBSCRIBER_NO=B.SUBSCRIBER_NO
WHERE A.EFFECTIVE_DATE=B.EXPIRATION_DATE 
AND A.SOC!=B.SOC
------------------------------- DEACTS DUE TO MIGRATIONS

SELECT A.*
INTO #DEACTS_MIGRATIONS
FROM #DEACTS A
INNER JOIN #GROSS_ADDS B
ON A.BAN=B.BAN
AND A.SUBSCRIBER_NO=B.SUBSCRIBER_NO
WHERE A.EXPIRATION_DATE=B.EFFECTIVE_DATE
AND A.SOC!=B.SOC


--------------------------------- TAG VP MIGRATION ADDS/DEACTS
----------------ADDS
SELECT A.*
, CASE 
WHEN B.BAN IS NULL 
THEN 0
ELSE 1
END AS "VP_MIGRATION_ADD"
INTO #METRICS_2
FROM #METRICS_1 A
LEFT OUTER JOIN #GROSS_ADDS_MIGRATIONS B
ON A.BAN=B.BAN
AND A.SUBSCRIBER_NO=B.SUBSCRIBER_NO
AND A.EFFECTIVE_DATE=B.EFFECTIVE_DATE

----------------DEACTS

SELECT A.*
, CASE 
WHEN B.BAN IS NULL 
THEN 0
ELSE 1
END AS "VP_MIGRATION_DEACT"
INTO #METRICS_3
FROM #METRICS_2 A
LEFT OUTER JOIN #DEACTS_MIGRATIONS B
ON A.BAN=B.BAN
AND A.SUBSCRIBER_NO=B.SUBSCRIBER_NO
AND A.EFFECTIVE_DATE=B.EFFECTIVE_DATE
AND A.EXPIRATION_DATE=B.EXPIRATION_DATE


















		
--------------------------------------------------------------- Closing Base for December


--select subscriber_no
--,ban
--into #december_base
--from ##musicservice
--	where EFFECTIVE_DATE <  '01/01/2012'
--AND (EXPIRATION_DATE >= '01/01/2012' or EXPIRATION_DATE is null)



--------------------------------------------------------------- Filter to See how many True Adds are in December Base



--select COUNT(distinct(cast(a.ban as varchar(20))+a.subscriber_no)) 
--from #LabelledGross1 a
--join #december_base b
--on a.subscriber_no=b.subscriber_no
--AND a.ban=b.ban
--where a.[ACCOUNT CHANGES] = 0
--AND a.MIGRATIONS = 0

-------------------------------------------------- 2006
	
	
	
--	---- 2006 / 3039 = STICKRATE !!!! =)
	
	
	
	
	
	
	