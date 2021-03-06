USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_DimResult_Merge]    Script Date: 12/17/2013 10:45:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_DimResult_Merge] 
AS
BEGIN 
	   MERGE INTO dbo.DimResult AS Tdest
	   USING
			(
			      SELECT distinct Result
				  FROM Stage.FactBet
			) AS Tsrc ON Tsrc.Result = Tdest.ResultName

		-- New attributes
		WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (ResultName) 
			VALUES (Tsrc.Result);
END 

