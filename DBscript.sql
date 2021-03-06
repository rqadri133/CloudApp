USE [master]
GO
/****** Object:  Database [TestDBTran]    Script Date: 11/9/2016 7:27:04 PM ******/
CREATE DATABASE [TestDBTran]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TestDBTran', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\TestDBTran.mdf' , SIZE = 1398976KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TestDBTran_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\TestDBTran.ldf' , SIZE = 3828544KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [TestDBTran] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TestDBTran].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TestDBTran] SET ANSI_NULL_DEFAULT ON 
GO
ALTER DATABASE [TestDBTran] SET ANSI_NULLS ON 
GO
ALTER DATABASE [TestDBTran] SET ANSI_PADDING ON 
GO
ALTER DATABASE [TestDBTran] SET ANSI_WARNINGS ON 
GO
ALTER DATABASE [TestDBTran] SET ARITHABORT ON 
GO
ALTER DATABASE [TestDBTran] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TestDBTran] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TestDBTran] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TestDBTran] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TestDBTran] SET CURSOR_DEFAULT  LOCAL 
GO
ALTER DATABASE [TestDBTran] SET CONCAT_NULL_YIELDS_NULL ON 
GO
ALTER DATABASE [TestDBTran] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TestDBTran] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [TestDBTran] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TestDBTran] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TestDBTran] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TestDBTran] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TestDBTran] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TestDBTran] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TestDBTran] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TestDBTran] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TestDBTran] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TestDBTran] SET RECOVERY FULL 
GO
ALTER DATABASE [TestDBTran] SET  MULTI_USER 
GO
ALTER DATABASE [TestDBTran] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TestDBTran] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TestDBTran] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TestDBTran] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [TestDBTran] SET DELAYED_DURABILITY = DISABLED 
GO
USE [TestDBTran]
GO
/****** Object:  UserDefinedTableType [dbo].[TestObligation]    Script Date: 11/9/2016 7:27:04 PM ******/
CREATE TYPE [dbo].[TestObligation] AS TABLE(
	[TestValueID] [uniqueidentifier] NOT NULL,
	[TestValueData] [decimal](9, 2) NULL,
	[CreatedBy] [nvarchar](18) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TestObligationMaxRule]    Script Date: 11/9/2016 7:27:04 PM ******/
CREATE TYPE [dbo].[TestObligationMaxRule] AS TABLE(
	[TestValueID] [uniqueidentifier] NOT NULL,
	[TestValueData] [decimal](9, 2) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](18) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TestObligationMaxRuleType]    Script Date: 11/9/2016 7:27:04 PM ******/
CREATE TYPE [dbo].[TestObligationMaxRuleType] AS TABLE(
	[TestValueID] [uniqueidentifier] NOT NULL,
	[TestValueData] [decimal](9, 2) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](18) NULL
)
GO
/****** Object:  Table [dbo].[TestObligationMaxRule]    Script Date: 11/9/2016 7:27:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestObligationMaxRule](
	[TestValueID] [uniqueidentifier] NOT NULL,
	[TestValueData] [decimal](9, 2) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](18) NULL
) ON [PRIMARY]

GO
/****** Object:  StoredProcedure [dbo].[spAddTestData]    Script Date: 11/9/2016 7:27:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spAddTestData] 
 
 @TestValue as decimal(9,2) ,
 @CDate  datetime 
 AS 
 Declare @tranName as nvarchar(200) 
 SET @tranName = 'DSTEST'
 BEGIN TRANSACTION  
  
  INSERT INTO TestObligationMaxRule VALUES (NEWID() , @TestValue , @CDate, 'SYSTEM' )

  IF @@ERROR <> 0 
  BEGIN
     ROLLBACK TRANSACTION @tranName
  END 
  ELSE
  BEGIN
   COMMIT
  END

GO
/****** Object:  StoredProcedure [dbo].[spAddTestDataAll]    Script Date: 11/9/2016 7:27:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spAddTestDataAll] 
 
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

GO
USE [master]
GO
ALTER DATABASE [TestDBTran] SET  READ_WRITE 
GO
