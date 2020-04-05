-------- STEP 1: VARIABALIZE THE LAST WEEK'S DATE (AS FORECAST IS DEPENDENT ON HOW MANY DAYS REMAIN RELATIVE TO THAT WEEK'S END)

DECLARE @END_DATE AS DATETIME
SET @END_DATE = (SELECT MAX(END_DATE) FROM [ENTERTAINMENT].[dbo].[RM_VALUEPACKS_WEEKLY])


-------- STEP 2: BRING IN GROSS ADDS FOR PAST 4 WEEKS

SELECT WEEK_NO, END_DATE
,CASE
	WHEN CAST(RATE AS VARCHAR(20)) = '12.79'
		THEN CAST(RATE AS VARCHAR(20))
	WHEN CAST(RATE AS VARCHAR(20)) = '16.79'
		THEN CAST(RATE AS VARCHAR(20))
	WHEN CAST(RATE AS VARCHAR(20)) = '20.79'
		THEN CAST(RATE AS VARCHAR(20))
	ELSE 'OTHER'
END AS "RATE"
,SUM([GROSS_ADDS]) AS "Gross_Adds" 
INTO #DAILY_1
FROM [ENTERTAINMENT].[dbo].[RM_VALUEPACKS_WEEKLY]
WHERE FRANCHISE = 'R'
and nontrueadd = 0
GROUP BY WEEK_NO, END_DATE, RATE



----------------- STEP 3:  TEMP FORECAST, WEEKLY AVERAGE DIVIDED BY 7 (DAILY AVERAGE) MULTIPLIED BY DAYS REMAINING IN MONTH
----------------- BRING IN DAYS REMAINING FROM TIM_DIM_MONTHLY *WITHOUT JOINING*

SELECT RATE, @END_DATE "END_DATE", SUM(GROSS_ADDS/4 ) /7 * DAYS_IN_MONTH AS "MONTHEND_FORECAST"
INTO #DAILY_2
FROM #DAILY_1,
STAGE.dbo.STG_TIME_DIM_MONTHLY 
WHERE @END_DATE BETWEEN SOM AND EOM
GROUP BY RATE, DAYS_IN_MONTH

----------------- STEP 4: COMPILE TABLES WITH ADDS AND FORECAST (UPDATE)

CREATE TABLE #DAILY_3
(WEEK_NO NUMERIC(9),
END_DATE DATETIME,
RATE VARCHAR(18),
GROSS_ADDS NUMERIC (18),
MONTHEND_FORECAST NUMERIC(18))
INSERT INTO #DAILY_3
(WEEK_NO,
END_DATE,
RATE,
GROSS_ADDS)
SELECT WEEK_NO, END_DATE, RATE, SUM(GROSS_ADDS) FROM #DAILY_1 
GROUP BY WEEK_NO, END_DATE, RATE

UPDATE #DAILY_3
SET MONTHEND_FORECAST = D.MONTHEND_FORECAST
FROM #DAILY_2 D INNER JOIN #DAILY_3 E ON E.END_DATE = D.END_DATE  AND D.RATE = E.RATE

DROP TABLE #DAILY_1
DROP TABLE #DAILY_2
DROP TABLE #DAILY_3