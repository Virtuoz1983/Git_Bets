USE [OlAP_Analysis]
GO

/****** Object:  StoredProcedure [dbo].[usp_DimDate_Feed]    Script Date: 12/9/2013 2:48:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_DimDate_Feed]
    @Year INT
AS
BEGIN 


WITH cte_dt_ranges
 AS
    (
    
       SELECT DATETIMEFROMPARTS(@year, 1, 1, 0,0,0,0) AS DateValue
         UNION ALL
       SELECT DateValue + 1
         FROM cte_dt_ranges
         WHERE DateValue + 1  <  DATEADD(yy, 1, DATETIMEFROMPARTS(@year, 1, 1, 0,0,0,0))
    )	

,cte_dates    
 AS
  (   
    SELECT
	        CONVERT(VARCHAR, DateValue, 112)	AS DateKey,
            CAST(DateValue AS date)				AS FullDateAlternateKey,
            DATEPART(dw, Datevalue)				AS DayNumberOfWeek,

			CASE DATEPART(dw, Datevalue)
					 WHEN 1 THEN 'Sunday'
					 WHEN 2 THEN 'Monday'
					 WHEN 3 THEN 'Tuesday'
					 WHEN 4 THEN 'Wednesday'
					 WHEN 5 THEN 'Thursday'
					 WHEN 6 THEN 'Friday'
					 WHEN 7 THEN 'Saturday'
					 END					AS DayNameOfWeek,			
			DATEPART(dd, datevalue)			AS DayNumberOfMonth,
            DATEPART(dy, datevalue)			AS DayNumberOfYear,            
			DATENAME(MONTH, datevalue)		AS [MonthName],
			DATEPART(M, datevalue)			AS MonthNumberOfYear,
            DATEPART(yyyy, datevalue)		AS CalendarYear			
    FROM cte_dt_ranges
)

  MERGE INTO dbo.DimDate AS Tdest
  USING 
      (
	    SELECT * FROM cte_dates    
	  ) AS Tsrc ON  Tdest.DateKey = Tsrc.DateKey
  
  WHEN NOT MATCHED THEN 
	  INSERT (
	           DateKey, FullDateAlternateKey, DayNumberOfWeek, DayNameOfWeek, DayNumberOfMonth, DayNumberOfYear, MonthName, MonthNumberOfYear, CalendarYear
			  )
	  VALUES (
	           Tsrc.DateKey, Tsrc.FullDateAlternateKey, Tsrc.DayNumberOfWeek, Tsrc.DayNameOfWeek, Tsrc.DayNumberOfMonth, Tsrc.DayNumberOfYear, Tsrc.MonthName, Tsrc.MonthNumberOfYear, Tsrc.CalendarYear
             ) 

OPTION (MAXRECURSION 0);



-- maintains statistics 
UPDATE STATISTICS dbo.DimDate WITH FULLSCAN

END;
GO


