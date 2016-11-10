USE [TestDBTran]
GO

/****** Object: SqlProcedure [dbo].[spAddTestDataAll] Script Date: 11/9/2016 7:18:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE [dbo].[spAddTestDataAll];


GO
Create Procedure spAddTestDataAll 
 
 @TestDataTbl TestObligation READONLY
 
 AS 
 Declare @tranName as nvarchar(200) 
 SET @tranName = 'DSTEST'
 BEGIN TRANSACTION  
  
  INSERT INTO TestObligationMaxRule ( TestValueID ,TestValueData ,CreatedBy , CreatedDate )
  SELECT TestValueID ,TestValueData ,CreatedBy ,GETDATE()  FROM  
  @TestDataTbl

  IF @@ERROR <> 0 
  BEGIN
     ROLLBACK TRANSACTION @tranName
  END 
  ELSE
  BEGIN
   COMMIT
  END
