USE [OlAP_Analysis]
GO

/****** Object:  StoredProcedure [dbo].[usp_DimBetResult_Merge]    Script Date: 12/17/2013 10:44:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DimBetResult_Merge] 
AS
BEGIN 

	   MERGE INTO dbo.DimBetResult AS Tdest
	   USING
			(
			      SELECT distinct BetResult
				  FROM Stage.FactBet
			) AS Tsrc ON Tsrc.BetResult = Tdest.BetResultName

		-- New attributes
		WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (BetResultName) 
			VALUES (Tsrc.BetResult);

END 
GO


