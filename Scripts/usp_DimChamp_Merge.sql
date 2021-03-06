USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_DimChamp_Merge]    Script Date: 12/17/2013 10:45:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_DimChamp_Merge] 
AS
BEGIN 

	   MERGE INTO dbo.DimChamp AS Tdest
	   USING
			(
			      SELECT distinct Champ
				  FROM Stage.FactBet
			) AS Tsrc ON Tsrc.Champ = Tdest.ChampName

		-- New attributes
		WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (ChampName) 
			VALUES (Tsrc.Champ);

END 