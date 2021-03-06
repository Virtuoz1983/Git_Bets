USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_DimKindOfSport_Merge]    Script Date: 12/17/2013 10:45:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_DimKindOfSport_Merge] 
AS
BEGIN 

	   MERGE INTO dbo.DimKindOfSport AS Tdest
	   USING
			(
			      SELECT distinct KindOfSport
				  FROM Stage.FactBet
			) AS Tsrc ON Tsrc.KindOfSport = Tdest.KindOfSportName

		-- New attributes
		WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (KindOfSportName) 
			VALUES (Tsrc.KindOfSport);

END 