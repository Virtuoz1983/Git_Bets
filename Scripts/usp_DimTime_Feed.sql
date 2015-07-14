USE [OlAP_Analysis]
GO

/****** Object:  StoredProcedure [dbo].[usp_DimTime_Feed]    Script Date: 12/9/2013 2:48:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_DimTime_Feed]

AS
BEGIN 



WITH cte_sec_ranges
 AS
    (
    
       SELECT 1 AS minu,  DATETIMEFROMPARTS(1900, 1, 1, 0,0,0,0) AS dt
       
	     UNION ALL
       
	   SELECT minu + 1, DATEADD(mi, 1, dt)
       FROM cte_sec_ranges
       WHERE minu  <  24 * 60 -- 
    )
 ,cte  
 AS
  (   
    SELECT
	        DATEPART(hour, dt) * 10000 + DATEPART(minute, dt) * 100 + DATEPART(second, dt)	AS TimeKey,
			CAST(dt AS time(0))												AS FullTimeAlternateKey,
            CONVERT(varchar(8), dt, 108)									AS Time24,                        
            [Hour]															AS [HourNumber],
            DATEPART(minute, dt)											AS [MinuteNumber],            
            AMPM															AS [AMPM]          
    FROM 
	 (
	  SELECT minu,
	         dt,
			 RIGHT(CONVERT(varchar, dt, 109), 2) AS AMPM,
			 DATEPART(hour, dt)					 AS [Hour]
	  FROM   cte_sec_ranges
	 ) AS T
)

--SELECT * FROM cte
--OPTION (MAXRECURSION 0);

  MERGE INTO dbo.DimTime AS Tdest
  USING 
      (
	    SELECT *
		FROM cte
	  ) AS Tsrc ON  Tdest.TimeKey = Tsrc.TimeKey
  
  WHEN NOT MATCHED THEN 
	  INSERT (
	           TimeKey, FullTimeAlternateKey, Time24, HourNumber, MinuteNumber, AMPM
			 )
	  VALUES (
	           Tsrc.TimeKey, Tsrc.FullTimeAlternateKey, Tsrc.Time24, Tsrc.HourNumber, Tsrc.MinuteNumber, Tsrc.AMPM
             ) 

OPTION (MAXRECURSION 0);



-- maintains statistics 
UPDATE STATISTICS dbo.DimTime WITH FULLSCAN;

END;

GO


