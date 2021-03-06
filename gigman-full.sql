USE [master]
GO
/****** Object:  Database [GigMan]    Script Date: 3/4/2016 1:18:46 PM ******/
CREATE DATABASE [GigMan] ON  PRIMARY 
( NAME = N'GigMan', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.VIM_SQLEXP\MSSQL\DATA\GigMan.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'GigMan_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.VIM_SQLEXP\MSSQL\DATA\GigMan_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [GigMan] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [GigMan].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [GigMan] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [GigMan] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [GigMan] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [GigMan] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [GigMan] SET ARITHABORT OFF 
GO
ALTER DATABASE [GigMan] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [GigMan] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [GigMan] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [GigMan] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [GigMan] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [GigMan] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [GigMan] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [GigMan] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [GigMan] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [GigMan] SET  ENABLE_BROKER 
GO
ALTER DATABASE [GigMan] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [GigMan] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [GigMan] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [GigMan] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [GigMan] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [GigMan] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [GigMan] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [GigMan] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [GigMan] SET  MULTI_USER 
GO
ALTER DATABASE [GigMan] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [GigMan] SET DB_CHAINING OFF 
GO
USE [GigMan]
GO
/****** Object:  User [GigMan]    Script Date: 3/4/2016 1:18:46 PM ******/
CREATE USER [GigMan] FOR LOGIN [GigMan] WITH DEFAULT_SCHEMA=[db_owner]
GO
ALTER ROLE [db_owner] ADD MEMBER [GigMan]
GO
ALTER ROLE [db_datareader] ADD MEMBER [GigMan]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [GigMan]
GO
/****** Object:  Schema [gigman]    Script Date: 3/4/2016 1:18:46 PM ******/
CREATE SCHEMA [gigman]
GO
/****** Object:  UserDefinedFunction [dbo].[InstrumentsFromIDs]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[InstrumentsFromIDs]
(
	-- Add the parameters for the function here
	@ids varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @retVal varchar(max) = ''

	declare @t table (id int)
	insert into @t select splitdata from SplitString(@ids,', ') 
	select @retVal = COALESCE(@retVal + ', ', '') + i.Name from instrument i inner join @t t on t.id = i.InstrumentID
	set @retval = substring(@retval,2,10000)
	RETURN @retVal

END


GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END

GO
/****** Object:  Table [dbo].[AllowedMediaType]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AllowedMediaType](
	[MediaTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](20) NOT NULL,
	[Extension] [varchar](20) NOT NULL,
 CONSTRAINT [PK_AllowedMediaTypes] PRIMARY KEY CLUSTERED 
(
	[MediaTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Announcement]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Announcement](
	[AnnouncementID] [int] IDENTITY(1,1) NOT NULL,
	[AnnouncementDate] [date] NOT NULL,
	[AnnouncementText] [text] NULL,
	[ArtistID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[CreationDate] [datetime] NULL,
	[Title] [varchar](127) NULL,
 CONSTRAINT [PK_Announcement] PRIMARY KEY CLUSTERED 
(
	[AnnouncementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Artist]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Artist](
	[ArtistID] [int] IDENTITY(1,1) NOT NULL,
	[Premium] [bit] NOT NULL,
	[ArtistName] [varchar](100) NOT NULL,
	[UserID] [int] NOT NULL,
	[Website] [varchar](127) NULL,
	[ShowCategories] [bit] NULL,
	[ShowArtist] [bit] NOT NULL,
	[ShowMembers] [bit] NOT NULL,
	[Public] [bit] NOT NULL,
	[EnableDownvotes] [bit] NOT NULL,
	[iRequestMember] [bit] NOT NULL,
	[MaxiMessages] [int] NOT NULL,
	[MaxiRequests] [int] NOT NULL,
	[LastPremiumPayDate] [datetime] NULL,
	[LastiRequestPayDate] [datetime] NULL,
	[iRequestName] [varchar](100) NULL,
	[Genres] [varchar](max) NULL,
	[RequestStatus] [bit] NOT NULL,
	[OffAirMessage] [varchar](500) NULL,
 CONSTRAINT [PK_Artist] PRIMARY KEY CLUSTERED 
(
	[ArtistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ArtistRole]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ArtistRole](
	[ArtistRoleID] [int] IDENTITY(1,1) NOT NULL,
	[Role] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ArtistRole] PRIMARY KEY CLUSTERED 
(
	[ArtistRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Calendar]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Calendar](
	[CalendarID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[Venue] [varchar](max) NULL,
	[SetupTime] [datetime] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Sets] [int] NULL,
	[ArtistID] [int] NULL,
	[UserID] [int] NOT NULL,
	[URL] [nvarchar](max) NULL,
	[Notes] [nvarchar](max) NULL,
	[Visibility] [int] NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_Calendar] PRIMARY KEY CLUSTERED 
(
	[CalendarID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Country]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](3) NULL,
	[Name] [varchar](255) NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Genre]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Genre](
	[GenreID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED 
(
	[GenreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[gigman (3)]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[gigman (3)](
	[Title] [varchar](255) NULL,
	[Lyrics] [varchar](8000) NULL,
	[Tempo] [int] NULL,
	[Notes] [varchar](8000) NULL,
	[Genre] [int] NULL,
	[Artist] [varchar](255) NULL,
	[Familiarity] [int] NULL,
	[Category] [varchar](255) NULL,
	[Sample] [varchar](1000) NULL,
	[ArtistID] [int] NULL,
	[Key] [int] NULL,
	[LastPlayed] [datetime] NULL,
	[PlayCount] [int] NULL,
	[Public] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IDs]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IDs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDType] [varchar](50) NULL,
 CONSTRAINT [PK_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[iMessage]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iMessage](
	[iMessageID] [int] IDENTITY(1,1) NOT NULL,
	[Message] [varchar](max) NOT NULL,
	[GroupRecipient] [int] NOT NULL,
 CONSTRAINT [PK_iMessage] PRIMARY KEY CLUSTERED 
(
	[iMessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Instrument]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Instrument](
	[InstrumentID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Parent] [int] NOT NULL,
 CONSTRAINT [PK_Instrument] PRIMARY KEY CLUSTERED 
(
	[InstrumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[iRequest]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iRequest](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ArtistID] [int] NULL,
	[RequestDate] [datetime] NULL,
	[SongID] [int] NULL,
	[Weight] [int] NULL,
	[IP] [varchar](50) NULL,
 CONSTRAINT [PK_iRequests] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[iRequestMessage]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iRequestMessage](
	[iRequestMessageID] [int] IDENTITY(1,1) NOT NULL,
	[Recipient] [int] NOT NULL,
	[Message] [varchar](max) NULL,
	[ArtistID] [int] NOT NULL,
	[MessageDate] [datetime] NOT NULL,
	[Attachment] [varchar](127) NULL,
	[Heading] [int] NOT NULL,
	[Multiple] [bit] NOT NULL,
	[IP] [varchar](50) NULL,
 CONSTRAINT [PK_iRequestMessage] PRIMARY KEY CLUSTERED 
(
	[iRequestMessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lookup]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lookup](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LookupType] [nvarchar](255) NULL,
	[LookupValue] [nvarchar](255) NULL,
	[Ordinal] [int] NULL,
 CONSTRAINT [aaaaaSongLookup_PK] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Payment]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Payment](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[PaymentPeriod] [int] NOT NULL,
	[PaymentAmount] [decimal](18, 2) NOT NULL,
	[PaymentContext] [int] NOT NULL,
	[ArtistID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[PaymentRecord] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PendingJoinRequest]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PendingJoinRequest](
	[JoinRequestID] [int] IDENTITY(1,1) NOT NULL,
	[ArtistID] [int] NULL,
	[UserID] [int] NULL,
	[RequestDate] [datetime] NULL,
	[Status] [bit] NULL,
	[ProcessDate] [datetime] NULL,
	[Message] [varchar](max) NULL,
 CONSTRAINT [PK_PendingJoinRequests] PRIMARY KEY CLUSTERED 
(
	[JoinRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Report]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Report](
	[ReportID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[ID] [int] NOT NULL,
	[ReportType] [varchar](50) NOT NULL,
	[Reason] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Role]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Role](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Role] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Session]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Session](
	[SessionID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[IP] [varchar](50) NOT NULL,
	[Data] [text] NOT NULL,
	[UserAgent] [varchar](50) NOT NULL,
	[LastActivity] [datetime] NOT NULL,
 CONSTRAINT [PK_Session] PRIMARY KEY CLUSTERED 
(
	[SessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SetList]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SetList](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SetName] [nvarchar](255) NULL,
	[SubsetName] [nvarchar](255) NULL,
	[Ordinal] [int] NULL,
	[SongID] [int] NULL,
	[ArtistID] [int] NOT NULL,
 CONSTRAINT [aaaaaSetList_PK] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Settings]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Settings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[VerseColor] [nvarchar](50) NULL,
	[AlternateVerseColor] [nvarchar](255) NULL,
	[ChorusColor] [nvarchar](255) NULL,
	[ChordsColor] [nvarchar](255) NULL,
	[SongListsColor] [nvarchar](255) NULL,
	[LyricsFont] [nvarchar](255) NULL,
	[LyricsFontSize] [nvarchar](255) NULL,
	[ChordsFont] [nvarchar](255) NULL,
	[ChordsFontSize] [nvarchar](255) NULL,
	[SongListsFont] [nvarchar](255) NULL,
	[SongListsFontSize] [nvarchar](255) NULL,
	[LyricsViewBackgroundColor] [nvarchar](255) NULL,
	[SongListsBackgroundColor] [nvarchar](255) NULL,
	[SongListsAlternateBackgroundColor] [nvarchar](255) NULL,
	[HRSeperator] [int] NULL,
	[HRSeperatorColor] [nvarchar](255) NULL,
	[SiteBackgroundColor] [nvarchar](255) NULL,
	[SiteTextColor] [nvarchar](255) NULL,
	[SiteFont] [nvarchar](255) NULL,
	[IgnoreArticleSort] [int] NULL,
	[BridgeColor] [nvarchar](255) NULL,
	[SiteFontSize] [int] NULL,
	[SuperscriptChords] [int] NULL,
	[RandomSongAsLink] [bit] NOT NULL,
 CONSTRAINT [aaaaaSettings_PK] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SiteSettings]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SiteSettings](
	[SiteSettingID] [int] IDENTITY(1,1) NOT NULL,
	[SiteSettingName] [varchar](50) NOT NULL,
	[SiteSettingValue] [varchar](max) NOT NULL,
 CONSTRAINT [PK_SiteSettings] PRIMARY KEY CLUSTERED 
(
	[SiteSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Song]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Song](
	[SongID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Lyrics] [text] NULL,
	[Tempo] [int] NULL,
	[Notes] [text] NULL,
	[Genre] [int] NULL,
	[Artist] [nvarchar](255) NOT NULL,
	[Familiarity] [int] NULL,
	[Category] [nvarchar](255) NULL,
	[Sample] [nvarchar](1000) NULL,
	[ArtistID] [int] NULL,
	[Key] [int] NULL,
	[LastPlayed] [datetime] NULL,
	[PlayCount] [int] NOT NULL,
	[Public] [bit] NOT NULL,
	[SongIDOld] [int] NULL,
	[AddedDate] [datetime] NULL,
 CONSTRAINT [aaaaaSong_PK] PRIMARY KEY NONCLUSTERED 
(
	[SongID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[State]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[State](
	[StateID] [int] IDENTITY(1,1) NOT NULL,
	[CountryCode] [varchar](3) NOT NULL,
	[Name] [varchar](255) NOT NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](255) NULL,
	[Password] [nvarchar](255) NULL,
	[Email] [nvarchar](255) NULL,
	[Active] [int] NULL,
	[PaidDate] [datetime] NULL,
	[LastLogin] [datetime] NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[CreationDate] [datetime] NULL,
	[Role] [varchar](100) NULL,
	[VerificationCode] [varchar](50) NULL,
	[Country] [varchar](3) NULL,
	[State] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[PostalCode] [varchar](255) NULL,
 CONSTRAINT [aaaaaUser_PK] PRIMARY KEY NONCLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserArtist]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserArtist](
	[UserArtistID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ArtistID] [int] NOT NULL,
	[ArtistRole] [varchar](max) NOT NULL,
	[AllowMessaging] [bit] NOT NULL,
 CONSTRAINT [PK_UserArtist] PRIMARY KEY CLUSTERED 
(
	[UserArtistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserInstrument]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInstrument](
	[UserInstrumentID] [int] IDENTITY(1,1) NOT NULL,
	[InstrumentID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_UserInstrument] PRIMARY KEY CLUSTERED 
(
	[UserInstrumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WantAd]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WantAd](
	[AdID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](256) NOT NULL,
	[Direction] [int] NOT NULL,
	[Instrument] [varchar](max) NOT NULL,
	[Location] [varchar](256) NOT NULL,
	[Text] [varchar](max) NOT NULL,
	[UserID] [nchar](10) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateModified] [datetime] NULL,
	[AdType] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Price] [decimal](18, 2) NULL,
	[Phone] [varchar](20) NULL,
 CONSTRAINT [PK_WantAds] PRIMARY KEY CLUSTERED 
(
	[AdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WantAdMedia]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WantAdMedia](
	[Type] [int] NOT NULL,
	[WantAdID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[WantAdMediaID] [int] IDENTITY(1,1) NOT NULL,
	[IsMain] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[Url] [varchar](500) NULL,
	[WantAdMediaDiskID] [int] NOT NULL,
 CONSTRAINT [PK_WantAdMedia] PRIMARY KEY CLUSTERED 
(
	[WantAdMediaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WantAdType]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WantAdType](
	[WantAdTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](50) NOT NULL,
	[Parent] [int] NOT NULL,
 CONSTRAINT [PK_WantAdTypes] PRIMARY KEY CLUSTERED 
(
	[WantAdTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [UserID]    Script Date: 3/4/2016 1:18:46 PM ******/
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[Settings]
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UserID]    Script Date: 3/4/2016 1:18:46 PM ******/
CREATE NONCLUSTERED INDEX [UserID] ON [dbo].[Song]
(
	[ArtistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AllowedMediaType] ADD  CONSTRAINT [DF_AllowedMediaTypes_Type]  DEFAULT ('Image') FOR [Type]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_Premium]  DEFAULT ((0)) FOR [Premium]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_ShowCategories]  DEFAULT ((0)) FOR [ShowCategories]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_ShowArtist]  DEFAULT ((0)) FOR [ShowArtist]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_ShowMembers]  DEFAULT ((1)) FOR [ShowMembers]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_Public]  DEFAULT ((1)) FOR [Public]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_EnableDownvotes]  DEFAULT ((1)) FOR [EnableDownvotes]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_iRequestMember]  DEFAULT ((0)) FOR [iRequestMember]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_MaxiMessagea]  DEFAULT ((5)) FOR [MaxiMessages]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_MaxiRequests]  DEFAULT ((5)) FOR [MaxiRequests]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_LastPremiumPayDate]  DEFAULT (NULL) FOR [LastPremiumPayDate]
GO
ALTER TABLE [dbo].[Artist] ADD  CONSTRAINT [DF_Artist_LastiRequestPayDate]  DEFAULT (NULL) FOR [LastiRequestPayDate]
GO
ALTER TABLE [dbo].[Artist] ADD  DEFAULT ((1)) FOR [RequestStatus]
GO
ALTER TABLE [dbo].[Calendar] ADD  CONSTRAINT [DF_Calendar_Notes]  DEFAULT ('') FOR [Notes]
GO
ALTER TABLE [dbo].[Calendar] ADD  CONSTRAINT [DF_Calendar_Public]  DEFAULT ((0)) FOR [Visibility]
GO
ALTER TABLE [dbo].[iMessage] ADD  CONSTRAINT [DF_iMessage_GroupRecipient]  DEFAULT ((1)) FOR [GroupRecipient]
GO
ALTER TABLE [dbo].[iRequestMessage] ADD  CONSTRAINT [DF_iRequestMessage_MessageDate]  DEFAULT (getdate()) FOR [MessageDate]
GO
ALTER TABLE [dbo].[iRequestMessage] ADD  CONSTRAINT [DF_iRequestMessage_Heading]  DEFAULT ((0)) FOR [Heading]
GO
ALTER TABLE [dbo].[iRequestMessage] ADD  CONSTRAINT [DF_iRequestMessage_Multiple]  DEFAULT ((0)) FOR [Multiple]
GO
ALTER TABLE [dbo].[Report] ADD  CONSTRAINT [DF_Report_ID]  DEFAULT ((0)) FOR [ID]
GO
ALTER TABLE [dbo].[Report] ADD  CONSTRAINT [DF_Report_ReportType]  DEFAULT ('Ad') FOR [ReportType]
GO
ALTER TABLE [dbo].[Report] ADD  CONSTRAINT [DF_Report_Reson]  DEFAULT ('-') FOR [Reason]
GO
ALTER TABLE [dbo].[SetList] ADD  CONSTRAINT [DF_SetList_UserID]  DEFAULT ((1)) FOR [ArtistID]
GO
ALTER TABLE [dbo].[Settings] ADD  DEFAULT ((0)) FOR [HRSeperator]
GO
ALTER TABLE [dbo].[Settings] ADD  DEFAULT ('0') FOR [SiteFont]
GO
ALTER TABLE [dbo].[Settings] ADD  DEFAULT ((14)) FOR [SiteFontSize]
GO
ALTER TABLE [dbo].[Settings] ADD  CONSTRAINT [DF_Settings_RandomSongAsLink]  DEFAULT ((0)) FOR [RandomSongAsLink]
GO
ALTER TABLE [dbo].[Song] ADD  CONSTRAINT [DF__Song__UserID__1BFD2C07]  DEFAULT ((0)) FOR [ArtistID]
GO
ALTER TABLE [dbo].[Song] ADD  CONSTRAINT [DF_Song_LastPlayed]  DEFAULT (CONVERT([datetime],'1753-1-1',0)) FOR [LastPlayed]
GO
ALTER TABLE [dbo].[Song] ADD  CONSTRAINT [DF_Song_PlayCount]  DEFAULT ((0)) FOR [PlayCount]
GO
ALTER TABLE [dbo].[Song] ADD  CONSTRAINT [DF_Song_Public]  DEFAULT ((0)) FOR [Public]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_CreationDate]  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[UserArtist] ADD  CONSTRAINT [DF_UserArtist_AllowMessaging]  DEFAULT ((1)) FOR [AllowMessaging]
GO
ALTER TABLE [dbo].[WantAd] ADD  CONSTRAINT [DF_WantAd_Seeking]  DEFAULT ((0)) FOR [Direction]
GO
ALTER TABLE [dbo].[WantAd] ADD  CONSTRAINT [DF_WantAd_Instrument]  DEFAULT ('') FOR [Instrument]
GO
ALTER TABLE [dbo].[WantAd] ADD  CONSTRAINT [DF_WantAd_Location]  DEFAULT ('') FOR [Location]
GO
ALTER TABLE [dbo].[WantAd] ADD  CONSTRAINT [DF_WantAd_Text]  DEFAULT ('') FOR [Text]
GO
ALTER TABLE [dbo].[WantAd] ADD  CONSTRAINT [DF_WantAds_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[WantAd] ADD  CONSTRAINT [DF_WantAd_Active]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[WantAdMedia] ADD  CONSTRAINT [DF_WantAdMedia_Name]  DEFAULT ('media') FOR [Name]
GO
ALTER TABLE [dbo].[WantAdMedia] ADD  CONSTRAINT [DF_WantAdMedia_IsMain]  DEFAULT ((0)) FOR [IsMain]
GO
ALTER TABLE [dbo].[WantAdMedia] ADD  CONSTRAINT [DF_WantAdMedia_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[WantAdMedia] ADD  CONSTRAINT [DF_WantAdMedia_WantAdMediaDiskID]  DEFAULT ((0)) FOR [WantAdMediaDiskID]
GO
ALTER TABLE [dbo].[WantAdType] ADD  CONSTRAINT [DF_WantAdType_Parent]  DEFAULT ((0)) FOR [Parent]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD FOREIGN KEY([RoleID])
REFERENCES [dbo].[Role] ([ID])
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_UserRole] FOREIGN KEY([ID])
REFERENCES [dbo].[UserRole] ([ID])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_UserRole]
GO
/****** Object:  StoredProcedure [dbo].[AddAnnouncement]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddAnnouncement]
@ArtistID int, @UserID int, @AnnouncementDate DateTime, @Text Text , @Title varchar(127)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Insert Into Announcement Values(cast (@AnnouncementDate as Date), @text, @ArtistID,@UserID,getDate(),@title)
	select @@IDENTITY
END

GO
/****** Object:  StoredProcedure [dbo].[AddVideo]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddVideo]
	@AdID int, @Key varchar(500),@Name varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    declare @c int
	select @c = count(*) from WantAdMedia where Type = 7 and WantAdID = @AdID and URL = @key
	if @c > 0
	begin
		SELECT -1
		RETURN
	end
	else insert into WantAdMedia (Type,WantAdID,Name,URL) values (7,@AdID,@Name,@Key)
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[AllowedMediaTypeListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AllowedMediaTypeListLoad]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from AllowedMediaType
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistAffiliationListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistAffiliationListLoad]
	 @UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select distinct a.*,dbo.InstrumentsFromIDs(ua.ArtistRole) as Role,
	 dbo.InstrumentsFromIDs(ua.ArtistRole) as Instrument,
	ua.AllowMessaging,ua.UserArtistID
	from artist a
	inner join userartist ua
	on ua.userid=@userid
	and ua.ArtistID=a.ArtistID
	where iRequestName <> 'info'
	order by Premium DESC, a.ArtistName ASC
	
END



GO
/****** Object:  StoredProcedure [dbo].[ArtistCreate]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistCreate] 
	@ArtistName varchar(100),@UserID int,@Website varchar(127),@ShowCategories bit,@ShowArtist bit, @ShowMembers bit, 
	@public bit,@EnableDownvotes bit,@maxMessages int, @maxRequests int, @iRequestName varchar(100),@genres varchar(max),@OffAirMessage varchar(500)
AS
BEGIN	
declare @id int
	select @id=ArtistID from Artist where userid=@userid and artistname = @artistname
	if isnull(@id,0) > 0 -- artist exists
	begin
		select '-1'
		return
	end

	Insert Into Artist (ArtistName, UserID,Website,ShowCategories, ShowArtist,ShowMembers,[Public],EnableDownvotes,MaxiMessages,MaxiRequests,iRequestName,Genres,OffAirMessage,RequestStatus) VALUES 
	(@ArtistName, @UserID,@Website,@ShowCategories, @ShowArtist,@ShowMembers,@public,@EnableDownvotes,@maxMessages,@maxRequests,@iRequestName,@genres,@OffAirMessage,1)

	SELECT @@ROWCOUNT;
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistDelete]
	@UserID int, @ArtistID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    delete from Artist where ArtistID=@ArtistID and UserID=@UserID
	delete from UserArtist where ArtistID=@ArtistID and UserID=@UserID
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistExists]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistExists]
	@ArtistName varchar(100), @UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT count(*) from artist where ArtistName = @ArtistName and UserID = @UserID
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistListByUserIDLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistListByUserIDLoad] 
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	exec ArtistPaymentUpdate
    -- Insert statements for procedure here
	select * from artist where artistid in
	(select distinct artistid from userartist where userid=@userID and iRequestName <> 'info')
	or userid=@userid
	 and iRequestName <> 'info'
END

GO
/****** Object:  StoredProcedure [dbo].[ArtistListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistListLoad]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	exec ArtistPaymentUpdate
    -- Insert statements for procedure here
	SELECT * from Artist where iRequestName <> 'info'
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistLoad]
	@ArtistName varchar(100), @ArtistID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	exec ArtistPaymentUpdate
	SET NOCOUNT ON;
	if isnull(@ArtistName, '') <> ''
	begin
		select * from Artist where ArtistName=@ArtistName
		return
	end
	if isnull(@ArtistID, 0) <> 0
	begin
		select * from Artist where ArtistID=@ArtistID
	end
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistLoadByiRequestName]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistLoadByiRequestName]
	@iRequestName varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select * from artist where iRequestName=@iRequestName
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistMemberDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistMemberDelete]
	@ArtistID int, @UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	delete from PendingJoinRequest where userid=@userid and artistid=@artistid and status = 1
	delete from UserArtist where ArtistID=@ArtistID and UserID = @UserID
  
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistMemberListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistMemberListLoad]
	@artistID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @roles table (id int, roles varchar(max), insts varchar(max));

	insert into @roles  select userid, ArtistRole, '' from userartist  where artistid=@artistid

	declare csr cursor for select id, roles from @roles
	declare @id int, @r varchar(max)
	open csr
	fetch next from csr into @id, @r
	while @@FETCH_STATUS = 0
	begin
		
		declare @rr varchar(max) = ''
		set @rr = dbo.InstrumentsFromIDs(@r)
		update	@roles
		set		insts = @rr
		
		where	id=@id
		set @r = ''
		fetch next from csr into @id, @r	
	end
	close csr
	deallocate csr

    -- Insert statements for procedure here
	SELECT r.insts as ArtistRole, a.ArtistName, u.UserID, u.FirstName, u.LastName, u.Username, u.Email, @artistID as ArtistID
	From UserArtist ua
	Inner Join [User] u
	on u.UserID = ua.UserID 
	and ua.ArtistID = @artistID
	and u.UserName <> 'guest'
	inner join Artist a
	on a.ArtistID = @artistID
	left join @roles r
	on r.id = ua.UserID
	where ua.ArtistID = @artistID
END



GO
/****** Object:  StoredProcedure [dbo].[ArtistPayment]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistPayment]
	@artistid int, @premiumpayment bit, @irequestpayment bit
AS
BEGIN
declare @cnt int
	set @cnt = 0

    if @premiumpayment = 1
	begin
		update artist 
		set LastPremiumPayDate=getdate(), Premium=1
		where ArtistID = @artistid

		set @cnt = @cnt + @@ROWCOUNT
	end

    if @irequestpayment = 1
	begin
		update artist 
		set LastiRequestPayDate=getdate(), 
		iRequestMember=1
		where ArtistID = @artistid

		set @cnt = @cnt + @@ROWCOUNT
	end
	select @cnt
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistPaymentUpdate]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistPaymentUpdate]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Update	Artist
	set		iRequestMember = 0 
	where	DATEDIFF(day,isnull(lastirequestpaydate,'1790-01-01'),getDate()) > 30
    Update	Artist
	set		Premium = 0 
	where	DATEDIFF(day,isnull(lastpremiumpaydate,'1790-01-01'),getDate()) > 30
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistRoleListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistRoleListLoad]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from artistrole
END


GO
/****** Object:  StoredProcedure [dbo].[ArtistSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArtistSave]
	@ArtistID int, @ArtistName varchar(100),@UserID int,@Website varchar(127),@ShowCategories bit,@ShowArtist bit, 
	@ShowMembers bit,@EnableDownvotes bit,@maxMessages int, @maxRequests int, @ispublic bit, @iRequestName varchar(100),@OffAirMessage varchar(500),@RequestStatus bit,
	@genres varchar(max)
AS
BEGIN	
	Update Artist set ArtistName=@ArtistName, Website=@Website,ShowCategories=@ShowCategories, ShowArtist=@ShowArtist,
	ShowMembers=@ShowMembers,EnableDownvotes=@EnableDownvotes,MaxiMessages=@maxMessages,MaxiRequests=@maxRequests,OffAirMessage=@OffAirMessage,RequestStatus=@RequestStatus,
	[Public]=@ispublic,iRequestName = @iRequestName,Genres=@genres
	where artistid=@ArtistID and UserID=@UserID
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[CalendarDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalendarDelete]
	@userid int, @artistid int, @calendarid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from calendar where artistid=@artistid and userid=@userid and calendarid=@calendarid
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[CalendarListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalendarListLoad]
	@userid int, @artistid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if isnull(@userid,0) > 0 and isnull(@artistid,0) > 0
	begin
		SELECT	* 
		from	calendar 
		where	artistid=@artistid 
		or		userid=@userid
		and		visibility < 2 -- 2 is private, 1 is visible to band, 0 is public
		return
	end
	if isnull(@artistid,0) = 0
	begin
		select	* 
		from	calendar
		where	userid=@userid
		return
	end
	if @userID = -1
	begin
		select	* 
		from	calendar
		where	artistid=@artistid
		and		visibility = 0
		return
	end
END


GO
/****** Object:  StoredProcedure [dbo].[CalendarSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalendarSave]
	@calendarID int, @artistID int, @userID int, @date datetime, @endtime datetime,
	@sets int, @setuptime datetime, @starttime datetime,@url varchar(max),@venue varchar(max),@notes nvarchar(MAX) ,@visibility int,@description varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if isnull(@calendarid,0) <> 0
	begin
		update Calendar set artistid=@artistID,userid=@userID,date=@date,
		endtime=@endtime,sets=@sets,setuptime=@setuptime,starttime=@starttime,url=@url,venue=@venue,visibility=@visibility,notes=@notes,description=@description
		where calendarid=@calendarID
		select @@ROWCOUNT
		return
	end
	else
	begin
		insert into Calendar (Date,Venue,SetupTime,StartTime,EndTime,Sets,ArtistID,UserID,URL,Visibility, Notes, Description)
		VALUES (@date,@venue,@setuptime,@starttime,@endtime,@sets,@artistID,@userID,@url,@visibility,@notes,@description)
		select @@IDENTITY
	end
END


GO
/****** Object:  StoredProcedure [dbo].[CalendarShift]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalendarShift]
	@calendarID int, @delta int
AS
BEGIN
	declare @date datetime, @starttime datetime, @endtime datetime, @setuptime datetime
	select @date = [date], @starttime = starttime, @endtime=endtime, @setuptime = setuptime
	from Calendar
	where CalendarID = @calendarID
	set @date = dateadd(day,@delta,@date)
	set @starttime = dateadd(day,@delta,@starttime)
	set @endtime = dateadd(day,@delta,@endtime)
	set @setuptime = dateadd(day,@delta,@setuptime)

	update Calendar set date = @date, starttime=@starttime,EndTime=@endtime,SetupTime=@setuptime
	where CalendarID=@calendarID

	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[CategoryListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadCategories 1
-- exec LoadArtists 1

CREATE  procedure [dbo].[CategoryListLoad]
	@ArtistID int
as
begin
declare @tbl table (category varchar(255),cnt int null)

insert  into @tbl select category,0 from song where artistID=@ArtistID and isnull(category,'') <> ''

declare csr cursor for select category from @tbl where charindex('/',category) > 0
declare @cat varchar(255)
open csr
fetch next from csr into @cat
while @@FETCH_STATUS = 0
begin
	insert into @tbl select splitdata,0 from dbo.SplitString(@cat,'/')
	fetch next from csr into @cat
end
close csr
deallocate csr

delete from @tbl where charindex('/',category) > 0

select category, count(*) as cnt
from	@tbl 
group by category
order	by category ASC

end

GO
/****** Object:  StoredProcedure [dbo].[CountryListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CountryListLoad]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from country order by name
END


GO
/****** Object:  StoredProcedure [dbo].[DeleteAnnouncement]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAnnouncement]
@ArtistID int, @UserID int, @AnnouncementID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    delete from Announcement  
	where ArtistID=@ArtistID
	and UserID = @UserID
	and AnnouncementID=@AnnouncementID

	select @@ROWCOUNT
END

GO
/****** Object:  StoredProcedure [dbo].[FamiliarityListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FamiliarityListLoad]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select ID,LookupValue as Name from Lookup
	Where LookupType = 'Familiarity'
	Order by ordinal
END


GO
/****** Object:  StoredProcedure [dbo].[GenreListByArtistIDLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GenreListByArtistIDLoad]
@ArtistID int
as
begin
select distinct genre.Name,genre.GenreID, count(*) from genre
inner join song
on song.genre=genre.genreid
and artistid=@ArtistID
group by Genre.Name,GenreID
end

GO
/****** Object:  StoredProcedure [dbo].[GenreListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenreListLoad]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select * from genre order by Name ASC
END


GO
/****** Object:  StoredProcedure [dbo].[GetAnnouncements]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAnnouncements]
@ArtistID int, @UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select * from Announcement  
	where ArtistID=@ArtistID
	and UserID = @UserID
	order by AnnouncementDate
	
END

GO
/****** Object:  StoredProcedure [dbo].[GetCountFromIP]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCountFromIP]
	@ip varchar(50), @artistID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * --SongID,Weight 
	from iRequest where ArtistID=@artistID and ip=@ip and datediff(hour,requestdate,getdate()) < 24
	SELECT count(*) from iRequestMessage where ArtistID=@artistID and ip=@ip and datediff(hour,messagedate,getdate()) < 24

END


GO
/****** Object:  StoredProcedure [dbo].[GetGMRAnnouncements]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetGMRAnnouncements]
@ArtistID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select * from Announcement  
	where ArtistID=@ArtistID
	and AnnouncementDate <= cast(getDate() as Date)

	
END

GO
/****** Object:  StoredProcedure [dbo].[GetLiveRequests]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetLiveRequests]
	@artistID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT top(10) ir.*, s.Artist,s.Title
	FROM iRequest ir
	inner join Song s
	on s.SongID = ir.SongID
	where requestdate >= DATEADD(DAY, 0, DATEDIFF(DAY, 0, CURRENT_TIMESTAMP))
	AND requestdate <  DATEADD(DAY, 1, DATEDIFF(DAY, 0, CURRENT_TIMESTAMP))
	and ir.ArtistID=@artistID
    
END


GO
/****** Object:  StoredProcedure [dbo].[GetPaymentHistory]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPaymentHistory]
	-- Add the parameters for the stored procedure here
	@artistID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from payment where artistid=@artistid
END


GO
/****** Object:  StoredProcedure [dbo].[GetRates]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetRates]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @gmmonthly varchar(Max),
			@gmyearly varchar(max),
			@irmonthly varchar(max),
			@iryearly varchar(max)
    -- Insert statements for procedure here
	SELECT @gmmonthly = SiteSettingValue
	from SiteSettings where SiteSettingName = 'GigManMonthlyRate'
	SELECT @gmyearly = SiteSettingValue
	from SiteSettings where SiteSettingName = 'GigManYearlyRate'
	SELECT @irmonthly = SiteSettingValue
	from SiteSettings where SiteSettingName = 'iRequestMonthlyRate'
	SELECT @iryearly = SiteSettingValue
	from SiteSettings where SiteSettingName = 'iRequestYearlyRate'
	declare @tmp table
	(
		Name varchar(100),
		Value varchar(max)
	)
	insert into @tmp (Name,Value) values ('GigManMonthlyRate',@gmmonthly)
	insert into @tmp (Name,Value) values ('GigManYearlyRate',@gmyearly)
	insert into @tmp (Name,Value) values ('iRequestMonthlyRate',@irmonthly)
	insert into @tmp (Name,Value) values ('iRequestYearlyRate',@iryearly)
	
	select * from @tmp
END


GO
/****** Object:  StoredProcedure [dbo].[GetRecentRequestCount]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetRecentRequestCount]
	@ip varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT songid from iRequest where ip=@ip and convert(date,dateadd(day,1,RequestDate)) = convert(date,getDate())
END


GO
/****** Object:  StoredProcedure [dbo].[GetSession]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSession]
	-- Add the parameters for the stored procedure here
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from [Session] where UserID=@UserID
END

GO
/****** Object:  StoredProcedure [dbo].[iMessageListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iMessageListLoad]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from iMessage;
END


GO
/****** Object:  StoredProcedure [dbo].[InstrumentList]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InstrumentList]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		declare @tbl table (InstrumentID int, Parent int, Name varchar(50))
declare csr cursor for select instrumentid, parent,name from instrument where parent=0 order by name
declare @id int, @parent int, @name varchar(50)
open csr
fetch next from csr into @id, @parent,@name

while @@FETCH_STATUS = 0
begin
	insert into @tbl (InstrumentID, Parent, Name) values (@id, @parent, @name)
	insert into @tbl select instrumentid, parent,name from instrument where parent = @id
	fetch next from csr into @id, @parent,@name
end
close csr
deallocate csr

select * from @tbl
END


GO
/****** Object:  StoredProcedure [dbo].[iRequestArtists]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestArtists] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from Artist where iRequestMember = 1 and [public] = 1
	order by ArtistName
END

GO
/****** Object:  StoredProcedure [dbo].[iRequestListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestListLoad]
	@artistID int, @today bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if @today = 1
	begin
		SELECT ir.songid, s.Artist,s.Title, Count(*) as requestCount, 
		(select count(*) from iRequest where iRequest.weight = 1 and iRequest.artistid=@artistID  and iRequest.songid=ir.songid) as upVotes, 
		(select count(*) from iRequest where iRequest.weight = -1 and iRequest.artistid=@artistID and iRequest.songid=ir.songid) as downVotes
		FROM iRequest ir  
		inner join song s 
		on s.songid = ir.songid 
		WHERE ir.ArtistID=@artistID
		and cast(requestdate as date) >= CAST(GETDATE() AS DATE)
		GROUP BY ir.songid,s.Artist,s.Title
	end
	else
	begin
		SELECT ir.songid, s.Artist,s.Title, Count(*) as requestCount, 
		(select count(*) from iRequest where iRequest.weight = 1 and iRequest.artistid=@artistID  and iRequest.songid=ir.songid) as upVotes, 
		(select count(*) from iRequest where iRequest.weight = -1 and iRequest.artistid=@artistID and iRequest.songid=ir.songid) as downVotes
		FROM iRequest ir  
		inner join song s 
		on s.songid = ir.songid 
		WHERE ir.ArtistID=@artistID
		GROUP BY ir.songid,s.Artist,s.Title
	end
END


GO
/****** Object:  StoredProcedure [dbo].[iRequestMessageDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestMessageDelete]
	@MessageID int
AS
BEGIN
	delete from iRequestMessage where iRequestMessageID = @MessageID
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[iRequestMessageListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestMessageListLoad]
	@ArtistID int, @Recipient varchar(max), @today bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @tmp as table
	(
		Recipient int,
		ArtistID int,
		Message varchar(max),
		Heading varchar(max),
		Attachment varchar(127),
		ID int,
		MessageDate DateTime,
		IP varchar(50)
	)
	if @today = 1
	begin
		insert into @tmp select Recipient,ArtistID,Message,cast(Heading as varchar(max)),Attachment,iRequestMessageID,MessageDate,IP from iRequestMessage
		WHERE ArtistID=@artistID
		and cast(messagedate as date) >= CAST(GETDATE() AS DATE)
		order by MessageDate ASC
	end
	else
	begin
		insert into @tmp select Recipient,ArtistID,Message,cast(Heading as varchar(max)),Attachment,iRequestMessageID,MessageDate,IP
		from iRequestMessage
		WHERE ArtistID=@artistID
		and Multiple = 0
		order by MessageDate ASC
	end
	if @Recipient > 0
	begin
		delete from @tmp where Recipient <> @Recipient
	end

	update	t
	set		t.Heading = i.Message
	from	@tmp as t
	inner	join iMessage i
	on		i.iMessageID = cast (t.Heading as int)

	select distinct Message,Heading,Attachment,ID,MessageDate, Recipient,IP
	from @tmp t
	order by MessageDate desc,Heading


END


GO
/****** Object:  StoredProcedure [dbo].[iRequestMessageLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestMessageLoad]
	@MessageID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Select	m.ArtistID,m.Attachment,m.iRequestMessageID,m.MessageDate,m.Recipient, m.Message, i.Message as Heading, IP
	from	iRequestMessage m
	left	join iMessage i
	on		i.iMessageID = m.Heading
	where	m.iRequestMessageID = @MessageID
END


GO
/****** Object:  StoredProcedure [dbo].[iRequestMessageSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestMessageSave]
	 @ArtistID int, @Recipients varchar(max), @Message varchar(max), @Heading int,@attachment varchar(127), @IP varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	declare @tbl table (id int)
	if @Recipients = '-1' or  patindex('%-1%',@recipients) > 0-- ALL
	begin

	insert into @tbl select UserID from userartist where ArtistID=@ArtistID
		Insert 
		into	irequestmessage select  t.ID,@message,@artistid,getDate(),@attachment,@Heading,1,@ip
		from @tbl t
		declare @idx int
		set @idx=@@IDENTITY
		update iRequestMessage set Multiple=0 where iRequestMessageID=@idx
	end
	else -- individuals
	begin
		insert into @tbl select splitdata as ID from splitstring(@Recipients,',')
		Insert 
		into	irequestmessage select  t.ID,@message,@artistid,getDate(),@attachment,@Heading,0,@IP
		from 
		@tbl t
	end
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[iRequestMessagesDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestMessagesDelete]
	-- Add the parameters for the stored procedure here
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from iRequestMessage where Recipient=@UserID
END


GO
/****** Object:  StoredProcedure [dbo].[iRequestMessageUpdate]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestMessageUpdate]
	@MessageID int, @Message int, @attachment varchar(127), @Heading int, @ip varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	Update iRequestMessage set Message=@Message, Attachment=@attachment, Heading=@Heading, MessageDate=GETdATE(), IP=@ip
	WHERE iRequestMessageID = @MessageID
    select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[iRequestNameExists]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestNameExists]
	-- Add the parameters for the stored procedure here
	@iRequestName varchar(100), @artistID int
AS
BEGIN
	select count(*) from Artist where iRequestName = @iRequestName and artistid <> @artistID
END


GO
/****** Object:  StoredProcedure [dbo].[iRequestSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[iRequestSave]
	@ArtistID int, @SongID int, @Weight int, @ip varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Insert into iRequest (ArtistID,RequestDate,SongID,Weight,IP) values (@ArtistID,getdate(),@SongID,@Weight,@ip)
	SELECT IDENT_CURRENT ('iRequest') AS iRequestID;
END


GO
/****** Object:  StoredProcedure [dbo].[iRequestStatsLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[iRequestStatsLoad]
	@artistID int
as 
begin
declare @hirq int,@hirqid int,
		@lorq int,@lorqid int,
		@hidv int,@hidvid int,
		@lodv int,@lodvid int,
		@hiuv int,@hiuvid int,
		@louv int,@louvid int,
		@himsg int, @himsgdate datetime,
		@lomsg int,@lomsgdate datetime;



set @hirq = (select top(1) c
from (select count(*) c, songid from iRequest where ArtistID=@artistID group by songid) l 
group by songid,c order by c desc)
set @hirqid = (select top(1) songID
from (select count(*) c, songid from iRequest where ArtistID=@artistID group by songid) l 
group by songid,c order by c desc)

set @lorq = (select top(1) c
from (select count(*) c, songid from iRequest where ArtistID=@artistID group by songid) l 
group by songid,c order by c asc)
set @lorqid = (select top(1) songID
from (select count(*) c, songid from iRequest where ArtistID=@artistID group by songid) l 
group by songid,c order by c asc)

set @hidv = (select top(1) c
from (select count(*) c, songid from iRequest where weight = -1 and ArtistID=@artistID group by songid) l 
group by songid,c order by c desc)
set @hidvid = (select top(1) songID
from (select count(*) c, songid from iRequest where weight = -1 and ArtistID=@artistID group by songid) l 
group by songid,c order by c desc)

set @lodv = (select top(1) c
from (select count(*) c, songid from iRequest where weight=-1 and ArtistID=@artistID group by songid) l 
group by songid,c order by c asc)
set @lodvid = (select top(1) songID
from (select count(*) c, songid from iRequest where weight=-1 and ArtistID=@artistID group by songid) l 
group by songid,c order by c asc)

set @hiuv = (select top(1) c
from (select count(*) c, songid from iRequest where weight = 1 and ArtistID=@artistID group by songid) l 
group by songid,c order by c desc)
set @hiuvid = (select top(1) songID
from (select count(*) c, songid from iRequest where weight = 1 and ArtistID=@artistID group by songid) l 
group by songid,c order by c desc)

set @louv = (select top(1) c
from (select count(*) c, songid from iRequest where weight=1 and ArtistID=@artistID group by songid) l 
group by songid,c order by c asc)
set @louvid = (select top(1) songID
from (select count(*) c, songid from iRequest where weight=1 and ArtistID=@artistID group by songid) l 
group by songid,c order by c asc)

select d into #t from (
select distinct cast(RequestDate as Date) as d from iRequest
union
select distinct cast (MessageDate as Date) as d from iRequestMessage
) as tmp
ALTER TABLE #t ADD id INT IDENTITY(1,1)  

DELETE FROM #t WHERE id NOT IN (SELECT MIN(id) _
	FROM #t GROUP BY d) 


SELECT distinct d = CONVERT(DATE, RequestDate), c = COUNT(*)
into #tmp
FROM dbo.iRequest ir
where ir.ArtistID=@artistID
GROUP BY CONVERT(DATE, RequestDate)

SELECT d = CONVERT(DATE, MessageDate), c = COUNT(*)
into #tmp2
FROM dbo.iRequestMessage irm
where irm.ArtistID=@artistID
GROUP BY CONVERT(DATE, MessageDate)



set @himsg= (select top(1) c from (select * from #tmp2 as Traffic) l order by c desc)
set @himsgdate= (select top(1) d from (select * from #tmp2 as Traffic) l order by c desc)
set @lomsg= (select top(1) c from (select * from #tmp2 as Traffic) l order by c asc)
set @lomsgdate= (select top(1) d from (select * from #tmp2 as Traffic) l order by c asc)


select @hirq as HiReq, @lorq as LoReq, @hidv as HiDV, @lodv as LoDV, @hiuv as HiUV, @louv as LoUV,@lomsg as LoMsg, @himsg as HiMsg,
 @hirqid as HiReqID, @lorqid as LoReqID, @hidvid as HiDVID, @lodvid as LoDVID, @hiuvid as HiUVID, @louvid as LoUVID,@lomsgdate as LoMsgDate,@himsgdate as HiMsgDate

declare @maxCR int,@maxCM int
select @maxcr = count(*) from #tmp
select @maxcm = count(*) from #tmp2

declare c cursor for select cast (d as date) from #t
declare @d as date
open c
fetch next from c into @d
truncate table #tmp
truncate table #tmp2
while @@FETCH_STATUS = 0
begin
declare @dd as date     
	insert into #tmp values (@d,(select count(*) from iRequest where cast(RequestDate as Date) = @d))
	insert into #tmp2 values (@d,(select count(*) from iRequestMessage where cast(MessageDate as Date) = @d))
	
	fetch next from c into @d
end
close c
deallocate c

select * from #tmp order by d asc
select * from #tmp2 order by d asc


drop table #tmp
drop table #tmp2
drop table #t

end


GO
/****** Object:  StoredProcedure [dbo].[KeyListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[KeyListLoad]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select ID,LookupValue as Name from Lookup
	Where LookupType = 'Key'
	Order by ordinal
END


GO
/****** Object:  StoredProcedure [dbo].[LookupListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadLookups 'tempo'
CREATE procedure [dbo].[LookupListLoad]
	 @LookupType varchar(255)
as 
begin
	Select ID, LookupValue as lValue from Lookup where LookupType=@LookupType order by Ordinal
end

GO
/****** Object:  StoredProcedure [dbo].[LookupNameLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LookupNameLoad]
	 @id int , @type varchar(255)
as
begin
Select LookupValue from Lookup where @ID=ID and @type = LookupType
end

GO
/****** Object:  StoredProcedure [dbo].[MakePayment]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MakePayment]
	@userID int, @artistID int, 
	@paymentPeriodGigMan int, @paymentAmountGigMan decimal(18,2), 
	@paymentPeriodRequest int, @paymentAmountRequest decimal(18,2), 
	@paymentRecord varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @expectedTotal decimal(18,2), @d decimal(18,2) = 0, @d2 decimal(18,2) = 0
	declare @prd varchar(100)
	if @paymentPeriodGigMan > 0
	begin
		set @prd = 'GigManYearlyRate'
		if @paymentPeriodGigMan = 1 
		begin
			set @prd = 'GigManMonthlyRate'
		end
			select @d = convert(decimal(18,2),SiteSettingValue) 
			from SiteSettings 
			where SiteSettingname = @prd
	end
	if @paymentPeriodRequest > 0
	begin
	set @prd = 'iRequestYearlyRate'
		if @paymentPeriodGigMan = 1 
		begin
			set @prd = 'iRequestMonthlyRate'
		end
			select @d2 = convert(decimal(18,2),SiteSettingValue) 
			from SiteSettings 
			where SiteSettingname = @prd
	end
	set @expectedTotal = @d + @d2
	if (@paymentAmountGigMan + @paymentAmountRequest) <> @expectedTotal
	begin
		select -1
	end
	if @paymentPeriodGigMan > 0
	begin
		insert into Payment (PaymentDate,PaymentPeriod,PaymentAmount,PaymentContext,ArtistID,UserID,PaymentRecord)
		values (GETDATE(),@paymentPeriodGigMan,@paymentAmountGigMan,1,@artistID,@userID,@paymentRecord)
		update Artist set Premium = 1, LastPremiumPayDate=getdate() where artistid=@artistID
	end
	if @paymentPeriodRequest > 0
	begin
		insert into Payment (PaymentDate,PaymentPeriod,PaymentAmount,PaymentContext,ArtistID,UserID,PaymentRecord)
		values (GETDATE(),@paymentPeriodRequest,@paymentAmountRequest,2,@artistID,@userID,@paymentRecord)
		update Artist set iRequestMember = 1, LastiRequestPayDate=getdate() where artistid=@artistID
	end

	select 1;
END


GO
/****** Object:  StoredProcedure [dbo].[NextID]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[NextID]
@type varchar(50)
as
begin
	insert into IDs (IDType) values(@type)
	select @@IDENTITY
end
GO
/****** Object:  StoredProcedure [dbo].[PendingJoinRequestByUserIDListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PendingJoinRequestByUserIDListLoad]
	@userid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select pjr.JoinRequestID, pjr.RequestDate,cast(isnull(pjr.Status,0) as bit) as Status, u.UserID, u.FirstName, u.LastName, u.Username, pjr.ArtistID, ArtistName
	from PendingJoinRequest pjr
	inner join [User] u
	on u.UserID=pjr.UserID
	inner join Artist a
	on a.ArtistID=pjr.ArtistID
	where pjr.UserID=@userID

END


GO
/****** Object:  StoredProcedure [dbo].[PendingJoinRequestCreate]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PendingJoinRequestCreate]
	@userID int, @artistid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

declare @id int
	select @id=UserID from [user] where userid=@userID
	if @id = null
	begin
		select 0
		return
	end
   select @id= count (*) from pendingJoinRequest
   where artistid=@artistid and userid=@userID
	if isnull(@id,0) > 0 
	begin
		select 0
		return
	end		
   Insert into pendingjoinrequest (userid,artistid,requestdate) values (@userid,@artistid,getdate())
   select IDENT_CURRENT ('PendingJoinRequest') AS ID;
END


GO
/****** Object:  StoredProcedure [dbo].[PendingJoinRequestListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PendingJoinRequestListLoad]
	@artistid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select pjr.JoinRequestID, pjr.RequestDate,pjr.Status, u.UserID, u.FirstName, u.LastName, u.Username, @ArtistID as ArtistID
	from PendingJoinRequest pjr
	inner join [User] u
	on u.UserID=pjr.UserID
	where pjr.ArtistID=@artistID

END


GO
/****** Object:  StoredProcedure [dbo].[PendingJoinRequestProcess]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PendingJoinRequestProcess]
	@RequestID int, @Status bit, @message varchar(MAX), @artistroleid varchar(max)
AS
BEGIN
	declare @res int = 0;
    Update PendingJoinRequest set Status = @status, ProcessDate = getdate(), Message=@message where  JoinRequestID = @requestID
	set @res = @@ROWCOUNT
	if (@status = 1)
	begin
	declare @aid int, @uid int
		select @uid = userid from pendingjoinrequest where joinrequestid=@requestid
		select @aid = artistid from pendingjoinrequest where joinrequestid=@requestid

		exec UserArtistSave @uid,@aid,@artistroleid
		set @res = @res + @@ROWCOUNT
	end
	select @res
END


GO
/****** Object:  StoredProcedure [dbo].[ReportAd]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ReportAd]
	-- Add the parameters for the stored procedure here
	@userid int, @adid int, @reason varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @c int
	select @c=count(*) from Report where UserID=@userid and ID=@adid
	if @c > 0 
	begin
		select -1;
		return
	end
    Insert Into Report (UserID,ID,ReportType,Reason) values (@userid,@adid,'Ad',@reason)
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[SaveSession]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveSession]
	@UserID int, @IP varchar(50),@Data text, @UserAgent varchar(50),@SessionID int 
AS
BEGIN
	if isnull(@SessionID,0) = 0
	begin
		Insert into Session values (@UserID, @IP,@Data,@UserAgent,getDate())
		Select @@IDENTITY
	end
	else
	begin
		update Session set ip = @ip, [data] = @data,UserAgent=@UserAgent where UserID=@UserID and SessionID=@SessionID
		select @@ROWCOUNT
	end
END

GO
/****** Object:  StoredProcedure [dbo].[SetlistDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SetlistDelete]
	-- Add the parameters for the stored procedure here
	@setName varchar(100),@subsetName varchar(100),@artistID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	if isnull(@setName,'') <> '' and isnull(@subsetName,'') <> ''
	begin
		delete 
		from	SetList 
		where	artistid=@artistID 
		and		SetName = @setName
		and		SubsetName = @subsetName
		select @@ROWCOUNT
		return
	end
	if isnull(@setName,'') <> '' 
	begin
		delete 
		from	setlist
		where	artistid=@artistid
		and		setname=@setName
		select @@ROWCOUNT
		return
	end
END


GO
/****** Object:  StoredProcedure [dbo].[SetlistListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadSetLists 1
CREATE procedure [dbo].[SetlistListLoad]
	 @artistID int
as 
begin
Select distinct SetName from SetList where ArtistID=@artistID
end

GO
/****** Object:  StoredProcedure [dbo].[SetlistLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadSetList 'market','gerry',2
CREATE procedure [dbo].[SetlistLoad]
	 @SetName varchar(255), @subSetName varchar(255), @ArtistID int
as
begin

Select	SongID, Ordinal
from	SetList
where	SetName=@SetName 
and		SubsetName=@subSetName
order	by ordinal

end

GO
/****** Object:  StoredProcedure [dbo].[SetlistSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SetlistSave]
		@ArtistID int = 1,
		@SetName varchar(255) = 'XXXX',
		@subSetName varchar(255) = 'XXX',
		@Songs varchar(Max) = '97|3,101|2,121|1'
as
begin
delete from SetList where SetName = @SetName and SubsetName=@SubSetName and artistid=@artistid

declare csr cursor for select splitdata from dbo.SplitString(@songs,',')
declare @buf varchar(20), @success int = 1
open csr
fetch next from csr into @buf
while @@FETCH_STATUS = 0
begin
declare @id varchar(10), @ord varchar(10)	
	

	SET @id = SUBSTRING(@buf, 0, PATINDEX('%|%',@buf))
    SELECT @id

    SET @ord = SUBSTRING(@buf, LEN(@id + '|') + 1,LEN(@buf))

	insert into SetList (SetName,SubsetName,Ordinal,SongID,ArtistID) VALUES (@setname,@subsetname,@ord,@id,@artistID)
	if @@ROWCOUNT = 0 set @success = 0
	fetch next from csr into @buf
end
close csr
deallocate csr

select @success


end



GO
/****** Object:  StoredProcedure [dbo].[SetlistSubsetListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadSubsets 'market'
CREATE procedure [dbo].[SetlistSubsetListLoad]
	 @SetName varchar(255), @ArtistID int
as 
begin
	Select distinct SubsetName from SetList Where SetName = @SetName and ArtistID=@ArtistID
end

GO
/****** Object:  StoredProcedure [dbo].[SettingsLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadSettings 1
CREATE procedure [dbo].[SettingsLoad]
	 @userID int
as 
begin
	Select * from Settings where UserID=@userid
end

GO
/****** Object:  StoredProcedure [dbo].[SettingsSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SettingsSave]
	@VerseColor varchar(50),
	@AlternateVerseColor varchar(255),
	@ChorusColor varchar(255),
	@ChordsColor varchar(255),
	@ChordsFontSize varchar(255),
	@SongListsColor varchar(255),
	@LyricsFont varchar(255),
	@LyricsFontSize varchar(255),
	@ChordsFont varchar(255),
	@SongListsFont varchar(255),
	@SongListsFontSize varchar(255),
	@LyricsViewBackgroundColor varchar(255),
	@SongListsBackgroundColor varchar(255),
	@SongListsAlternateBackgroundColor varchar(255),
	@HRSeperator int,
	@HRSeperatorColor varchar(255),
	@SiteBackgroundColor varchar(255),
	@SiteTextColor varchar(255),
	@SiteFont varchar(255),
	@UserID varchar(255),
	@IgnoreArticleSort bit,
	@BridgeColor varchar(255),
	@SiteFontSize int,
	@SuperscriptChords bit,
	@RandomSongAsLink bit
as
begin
declare @found int
	select @found=count(*) from settings where userid=@userid
	if @found > 0
	begin
		update settings
		set VerseColor=@VerseColor,
			AlternateVerseColor=@AlternateVerseColor,
			ChorusColor=@ChorusColor,
			ChordsColor=@ChordsColor,
			ChordsFontSize=@ChordsFontSize,
			SongListsColor=@SongListsColor,
			LyricsFont=@LyricsFont,
			LyricsFontSize=@LyricsFontSize,
			ChordsFont=@ChordsFont,
			SongListsFont=@SongListsFont,
			SongListsFontSize=@SongListsFontSize,
			LyricsViewBackgroundColor=@LyricsViewBackgroundColor,
			SongListsBackgroundColor=@SongListsBackgroundColor,
			SongListsAlternateBackgroundColor=@SongListsAlternateBackgroundColor,
			HRSeperator=@HRSeperator,
			HRSeperatorColor=@HRSeperatorColor,
			SiteBackgroundColor=@SiteBackgroundColor,
			SiteTextColor=@SiteTextColor,
			SiteFont=@SiteFont,
			IgnoreArticleSort=@IgnoreArticleSort,
			BridgeColor=@BridgeColor,
			SiteFontSize=@SiteFontSize,
			SuperscriptChords=@SuperscriptChords,
			RandomSongAsLink=@RandomSongAsLink
		where userid=@userid
	end
	else
	begin
		insert into settings
		(
			VerseColor,
			AlternateVerseColor,
			ChorusColor,
			ChordsColor,
			ChordsFontSize,
			SongListsColor,
			LyricsFont,
			LyricsFontSize,
			ChordsFont,
			SongListsFont,
			SongListsFontSize,
			LyricsViewBackgroundColor,
			SongListsBackgroundColor,
			SongListsAlternateBackgroundColor,
			HRSeperator,
			HRSeperatorColor,
			SiteBackgroundColor,
			SiteTextColor,
			SiteFont,
			UserID,
			IgnoreArticleSort,
			BridgeColor,
			SiteFontSize,
			SuperscriptChords,
			RandomSongAsLink
		)
		values
		(
			@VerseColor,
			@AlternateVerseColor,
			@ChorusColor,
			@ChordsColor,
			@ChordsFontSize,
			@SongListsColor,
			@LyricsFont,
			@LyricsFontSize,
			@ChordsFont,
			@SongListsFont,
			@SongListsFontSize,
			@LyricsViewBackgroundColor,
			@SongListsBackgroundColor,
			@SongListsAlternateBackgroundColor,
			@HRSeperator,
			@HRSeperatorColor,
			@SiteBackgroundColor,
			@SiteTextColor,
			@SiteFont,
			@UserID,
			@IgnoreArticleSort,
			@BridgeColor,
			@SiteFontSize,
			@SuperscriptChords,
			@RandomSongAsLink
		)
	end
	select @@ROWCOUNT
end

GO
/****** Object:  StoredProcedure [dbo].[SongArtistListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[SongArtistListLoad]
	@ArtistID int
as
begin
declare @tbl table (artist varchar(255),cnt int null)

insert  into @tbl select artist,0 from song where ArtistID=@ArtistID

declare csr cursor for select artist from @tbl where charindex('/',artist) > 0
declare @art varchar(255)
open csr
fetch next from csr into @art
while @@FETCH_STATUS = 0
begin
	insert into @tbl select splitdata,0 from dbo.SplitString(@art,'/')
	fetch next from csr into @art
end
close csr
deallocate csr

delete from @tbl where charindex('/',artist) > 0

select Artist, count(*) as Count
from	@tbl 
group by artist
order	by artist ASC

end

GO
/****** Object:  StoredProcedure [dbo].[SongByAttributeLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SongByAttributeLoad]
	 @Artist varchar(100), @Title varchar(100), @ArtistID int
as
begin

select	s.*, k.lookupvalue as sKey, f.lookupvalue as sFamiliarity, g.Name as sGenre, t.lookupvalue as sTempo
from	song s
left join lookup k
on k.lookuptype='key' and k.id=s.[Key]
left join lookup f
on f.lookuptype='familiarity' and f.id = s.Familiarity
left join lookup t
on t.lookuptype='tempo' and t.id=s.Tempo
left join Genre g
on g.GenreID = s.Genre
where Artist = @artist and @title = Title and ArtistID = @artistID
end

GO
/****** Object:  StoredProcedure [dbo].[SongDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SongDelete] 
	@SongID int
as
begin
	delete from song where SongID=@SongID
	select @@ROWCOUNT
end

GO
/****** Object:  StoredProcedure [dbo].[SongListAllLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadSongs '',1,0
CREATE procedure [dbo].[SongListAllLoad] 
	 @artistID int
as
begin

	Select	s.*
	from	song s	
	where	artistID=@artistID
	order by Title ASC

end

GO
/****** Object:  StoredProcedure [dbo].[SonglistLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadSongsByAttribute 'DESC',1,'',0,'',40,52
CREATE procedure [dbo].[SonglistLoad]
	@sortDir varchar(10), @sortByArtist bit, 
	@artist varchar(255),@genre int, @category varchar(255),@tempo int, @familiarity int, @ArtistID int
as
begin

select s.*
into #tmp 
from song s
where ArtistID = @ArtistID

if isnull(@artist,'') <> ''  
begin 
	delete from #tmp where artist not like '%' + @artist + '%' or artist is null
end
if isnull(@Genre,0) > 0 delete from #tmp where genre <> @genre

if isnull(@category,'') <> ''  
begin 
	delete from #tmp where category not like '%' + @category + '%' or category is null
end
if isnull(@tempo,0) > 0 delete from #tmp where tempo <> @tempo
if isnull(@familiarity,0) > 0 delete from #tmp where familiarity <> @familiarity

if isnull(@sortDir,'') = 'ASC'
begin
	if @sortByArtist = 1 select * from #tmp order by artist ASC
	if @sortByArtist = 0 select * from #tmp order by title ASC
end
else if isnull(@sortDir,'') = 'DESC'
begin
	if @sortByArtist = 1 select * from #tmp order by artist DESC
	if @sortByArtist = 0 select * from #tmp order by title DESC
end
else
begin
	select * from #tmp
end
drop table #tmp
end



GO
/****** Object:  StoredProcedure [dbo].[SonglistPublicLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadSongsByAttribute 'DESC',1,'',0,'',40,52
CREATE procedure [dbo].[SonglistPublicLoad]
	@ArtistID int
as
begin

select s.*,k.lookupvalue as sKey, f.lookupvalue as sFamiliarity, g.Name as sGenre, t.lookupvalue as sTempo
from song s
left join lookup k
on k.lookuptype='key' and k.id=s.[Key]
left join lookup f
on f.lookuptype='familiarity' and f.id = s.Familiarity
left join lookup t
on t.lookuptype='tempo' and t.id=s.Tempo
left join Genre g
on g.GenreID = s.Genre
where ArtistID = @ArtistID
and [Public] = 1


end



GO
/****** Object:  StoredProcedure [dbo].[SongLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SongLoad]
	 @songID int
as
begin

select	s.*
from	song s
where SongID = @songid
end

GO
/****** Object:  StoredProcedure [dbo].[SongRandomLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LoadRandomSong 0
CREATE  procedure [dbo].[SongRandomLoad]
	@ArtistID int
as 
begin
declare @id int
	set @id = (select top 1 SongID from song where ArtistID=@ArtistID 
	order by newid())
	exec SongLoad @id
end


GO
/****** Object:  StoredProcedure [dbo].[SongSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SongSave]
	 @artist varchar(100), @title varchar(100),@lyrics ntext,@tempo int,@notes ntext,@genre int, 
	@familiarity int,@category varchar(255),@sample varchar(255),@key varchar(1000), 
	@artistID int,@public bit, @songID int
as
begin
declare @id int
select @id=songid from song where artist=@artist and title=@title and ArtistID=@artistID
if isnull(@id,0) > 0 set @songID=@id
if isnull(@songid,0) > 0 -- the song exists
begin
	Update Song
	set artist=@artist,title=@title,lyrics=@lyrics,tempo=@tempo,Notes=@notes,genre=@genre,familiarity=@familiarity,
	category=@category,sample=@sample,[Key]=@key,[Public]=@public
	where songID=@songID
	if (@@ROWCOUNT > 0) 
	begin 
		select @songid
	end
	else
	begin
		select 0;
	end
end
else
begin
	Insert into Song
	(Title,Lyrics,Tempo,Notes,Genre,Artist,Familiarity,Category,Sample,[Key],[Public],ArtistID,AddedDate)
	VALUES
	(@title,@lyrics,@tempo,@notes,@genre,@artist,@familiarity,@category,@sample,@key,@public,@artistID,getdate())

	if @@ROWCOUNT > 0
	begin
		Select @@IDENTITY
	end
	else
	begin
		Select 0
	end
end

end

GO
/****** Object:  StoredProcedure [dbo].[SongUpdateAccess]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SongUpdateAccess]
	-- Add the parameters for the stored procedure here
	@SongID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    update	song 
	set		lastplayed=getdate(), playcount = playcount+1
	where	songid=@SongID

	select playcount from song where songid=@SongID
END


GO
/****** Object:  StoredProcedure [dbo].[StateListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[StateListLoad]
@country varchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (isnull(@country,'') = '')
	begin
		SELECT * from state order by countrycode,name
	end
	else
	begin
		SELECT * from state where countrycode = @country order by name
	end
	
END

GO
/****** Object:  StoredProcedure [dbo].[TempoListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TempoListLoad]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select ID,LookupValue as Name from Lookup
	Where LookupType = 'Tempo'
	Order by ordinal
END


GO
/****** Object:  StoredProcedure [dbo].[UpdateAnnouncement]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAnnouncement]
@ArtistID int, @UserID int, @AnnouncementDate DateTime, @Text Text, @ID int, @title varchar(127)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Update Announcement  set AnnouncementDate = cast (@AnnouncementDate as Date), AnnouncementText = @text, Title=@title
	where ArtistID=@ArtistID
	and UserID = @UserID
	and AnnouncementID=@id

	select @@ROWCOUNT
END

GO
/****** Object:  StoredProcedure [dbo].[UserArtistDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserArtistDelete]
	-- Add the parameters for the stored procedure here
	@userID int, @artistid int, @artistRole int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    delete from userartist where @userid=userid and @artistid=artistid and @artistRole=ArtistRole
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[UserArtistMessaging]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserArtistMessaging]
	@UserArtistID int, @value bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Update UserArtist set AllowMessaging=@value where UserArtistID=@UserArtistID
   select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[UserArtistSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserArtistSave] 
	@UserID int, @ArtistID int, @ArtistRole varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare @id int
	select @id=UserArtistID from UserArtist where @UserID=UserID and ArtistID=@ArtistID
    if isnull(@id,0) > 0
	begin
		update UserArtist set ArtistRole = @ArtistRole where userid=@userid and artistid=@artistid
		select @@ROWCOUNT
		return
	end
	else
	begin
		insert into UserArtist (UserID,ArtistID,ArtistRole) values (@UserID,@ArtistID,@ArtistRole)
		SELECT IDENT_CURRENT ('UserArtist') AS UserArtistID;
		return
	end
	select -1
END


GO
/****** Object:  StoredProcedure [dbo].[UserCreate]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UserCreate]
	@username varchar(255), @email varchar(255), @password varchar(255), @firstname varchar(100),
	@lastname varchar(100), @role varchar(100),@code varchar(40),@country varchar(3),@state varchar(255),
	@city varchar(255), @postalcode varchar(255)
as
begin
	insert into [User] (UserName, Password, Email, Active, PaidDate,FirstName,LastName,VerificationCode,COuntry,State,City,PostalCode)
			VALUES (@username,@password,@email,0,null,@firstname,@lastname,@code,@country,@state,@city,@postalcode)
declare @userID int	
	SELECT @userID = IDENT_CURRENT ('User')
	exec UserInstrumentSave @userid,@role 
	select @userID
end

GO
/****** Object:  StoredProcedure [dbo].[UserDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserDelete]
	-- Add the parameters for the stored procedure here
	@userID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from [user] where userid=@userid
	delete from iRequestMessage where recipient=@userid
	delete from PendingJoinRequest where userid=@userid
	delete from settings where userid=@userid
	delete from UserInstrument where userid=@userid

END

GO
/****** Object:  StoredProcedure [dbo].[UserExists]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UserExists] @userName varchar(255), @email varchar(255)
as
begin
declare @n int, @e int
declare @val int = 0
	
	select @n=count(*) from [User] where username=@userName
	select @e=count(*) from [User] where email=@email

	if @n > 0 set @val = 1
	if @e > 0 set @val = @val + 2

	select @val -- 1 if username exists, 2 if email has been used, 3 if both exist
end

GO
/****** Object:  StoredProcedure [dbo].[UserInstrumentByUserList]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserInstrumentByUserList]
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select ui.*,i.Name
	from UserInstrument ui
	inner join Instrument i
	on i.InstrumentID=ui.InstrumentID
	where UserID=@UserID
END


GO
/****** Object:  StoredProcedure [dbo].[UserInstrumentSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserInstrumentSave]
	@UserID int, @InstrumentList varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select @UserID as UserID,splitdata into #tmp from dbo.SplitString(@InstrumentList,',')

    delete from UserInstrument where UserID = @UserID

	insert into UserInstrument (UserID,InstrumentID)
	select UserID,splitdata
	from #tmp

	drop table #tmp

END


GO
/****** Object:  StoredProcedure [dbo].[UserLogIn]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec LogIn 'JamesAlbert', 'diamondJames'
CREATE   procedure [dbo].[UserLogIn]
	@UserName varchar(255), @Password varchar(255)
as 
begin
declare @ok int
declare @id int
	select @id=UserID from [User] Where Username=@UserName and password=@Password
	select @ok=count(*) from [User] where UserName=@username and active=1 and password=@password COLLATE Latin1_General_CS_AS 
	if @ok = 1 
	begin
		update [user] set lastlogin= getdate()

		select *,
		(SELECT top 1 (STUFF((SELECT CAST(', ' + cast(InstrumentID as varchar(max)) AS VARCHAR(MAX)) 
         FROM UserInstrument 
         WHERE (UserID = @id) 
         FOR XML PATH ('')), 1, 2, '')) AS Instruments
		FROM UserInstrument) as Instruments
		 
		from [User] 
		where UserName=@username 
		and active=1 
		and password=@password 
		COLLATE Latin1_General_CS_AS 
	end
end



GO
/****** Object:  StoredProcedure [dbo].[UsersInstrumentByInstrumentList]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UsersInstrumentByInstrumentList]
	@InstrumentID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select distinct ui.userid 
	from UserInstrument  ui
	inner join Instrument i
	on i.InstrumentID=@InstrumentID
	where ui.InstrumentID=@InstrumentID
END


GO
/****** Object:  StoredProcedure [dbo].[UserUpdate]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UserUpdate]
	
	@userID int,@email varchar(255), @password varchar(255), @firstname varchar(100),@lastname varchar(100), @role varchar(100),
	@instruments varchar (max),@country varchar(3), @state varchar(255), @city varchar(255), @postalcode varchar(255)
as
begin
	if isnull(@password,'') <> ''
	begin
		update [User] set Password=@password, Email=@email, FirstName=@firstname,LastName=@lastname,Country=@country,State=@state,City=@city,PostalCode=@postalcode
		where UserID=@userID
	end
	else
	begin
		update [User] set Email=@email, FirstName=@firstname,LastName=@lastname,[Role]=@role,Country=@country,State=@state,City=@city,PostalCode=@postalcode
		where UserID=@userID
	end
	
	declare @rc int
	SELECT @rc = @@ROWCOUNT;
	if isnull(@instruments,'') <> '' 
	begin 
		exec UserInstrumentSave @userID,@instruments 
	end
	else
	begin
		delete from UserInstrument where userid=@userID
	end
	select @rc
end

GO
/****** Object:  StoredProcedure [dbo].[UserVerify]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserVerify]
	@Code uniqueidentifier,@email varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @dt datetime, @id int
    select @id=UserID, @dt=CreationDate
	from [User]
	Where Email=@email and VerificationCode=@code
	if @id is not null and datediff(hour,@dt,getdate()) < 24
	begin
		update [User] set VerificationCode = null, Active = 1
		where UserID = @id 
		select * from [User] where UserID=@id
	end
	else if datediff(hour,@dt,getdate()) >= 24
	begin
		delete from [User] where UserID=@id
	end
END


GO
/****** Object:  StoredProcedure [dbo].[WantAdDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdDelete]
	@UserID int,  @AdID int
AS
BEGIN

	delete from wantad where UserID=@userid and AdID=@adid    
	delete from wantadmedia where wantadid=@adid
END


GO
/****** Object:  StoredProcedure [dbo].[WantAdListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdListLoad]
	@dir int,@adType int,@userID int
AS
BEGIN

select * into #tmp from wantad

declare @parent int
select @parent = parent from wantadtype where wantadtypeid=@adtype

if @dir = 2 delete from #tmp where direction = 1
if @dir = 1 delete from #tmp where direction = 0
if @parent = 0 delete from #tmp where adtype not in (select wantadtypeid from wantadtype where parent=@adtype)
if @parent <> 0 delete from #tmp where adtype <> @adtype
if @userID > 0 delete from #tmp  where UserID <> @userID

select	w.*, wm.Type,wm.DateCreated as MediaDateCreated, wm.IsMain,wm.Name,wm.WantAdID,wm.WantAdMediaID,wm.Url, wm.WantAdMediaDiskID
			from #tmp w
			left join wantadmedia wm
			on w.adid = wm.wantadID

drop table #tmp
END


GO
/****** Object:  StoredProcedure [dbo].[WantAdLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdLoad]
	@adid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		select w.*, wm.Type,wm.WantAdMediaID,wm.Name,wm.IsMain,wm.datecreated as MediaDateCreated,wm.url, wm.WantAdMediaDiskID
		from wantad	w
		left join WantAdMedia wm
		on wm.wantadid=w.adid
		where w.AdID = @adid

END


GO
/****** Object:  StoredProcedure [dbo].[WantAdMediaDelete]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdMediaDelete]
	@MediaID int
AS
BEGIN

	delete from wantadmedia where WantAdMediaID=@mediaid    
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[WantAdMediaListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdMediaListLoad]
	@AdId int
AS
BEGIN

	select * from wantadmedia where wantadid=@adid
END


GO
/****** Object:  StoredProcedure [dbo].[WantAdMediaRename]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdMediaRename]
	@mediaid int, @name varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update WantAdMedia set name=@name where WantAdMediaID=@mediaID
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[WantAdMediaSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdMediaSave]
	@MediaID int,@IsMain bit, @Name varchar(50), @Type int,@AdId int,@url varchar(500) = ''
AS
BEGIN
	declare @nVid int, @nAud int, @nImg int
	select @nVid = count(*) from WantAdMedia where @adid=WantAdID and type in (select mediatypeid from AllowedMediaType where type='video')
	select @nAud = count(*) from WantAdMedia where @adid=WantAdID and type in (select mediatypeid from AllowedMediaType where type='audio')
	select @nImg = count(*) from WantAdMedia where @adid=WantAdID and type in (select mediatypeid from AllowedMediaType where type='image')

	--print cast(@nvid as varchar(100)) + ' ' + cast(@nAud as varchar(100)) + ' ' + cast(@nImg as varchar(100))

	if (@type in (1,2,3,4) and @nImg = 8) or
	(@type in (5,6) and @nAud = 2) or
	(@type = 7 and @nVid = 3) 
	begin
		select -1
		return
	end 
	--print @type
	delete from wantadmedia where WantAdID = @AdId and WantAdMediaDiskID = @MediaID
	--print 'MediaID is 0'
	insert into wantadmedia (Type,WantAdID,Name,IsMain,Url,WantAdMediaDiskID) VALUES
	(@Type,@adid,@name,@ismain,@url,@MediaID)
	select IDENT_CURRENT('wantadmedia')
END

GO
/****** Object:  StoredProcedure [dbo].[WantAdSave]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdSave]
	@UserID int, @AdType int, @Instrument varchar(max), @Location varchar(256),@Direction int, @Text varchar(max),
	@Title varchar(256), @AdID int, @price decimal(18,2), @phone varchar(20)
AS
BEGIN
declare @cnt int
	select @cnt = count(*) 
	from wantad 
	where UserID=@userid and @Location=Location and Instrument = @Instrument and Direction=@Direction and [text] = @text and @Title=title and @price=price and Phone=@phone and @adid = 0
	if @cnt > 0
	begin
		select 0
		return
	end
	if isnull(@AdID,0) = 0
	begin
		Insert into WantAd (UserID,AdType,Instrument,Location,Direction,text,Title,Price,Phone)
		Values (@UserID,@AdType,@Instrument,@Location,@Direction,@text,@Title,@price,@phone)
		if @@ROWCOUNT > 0 select SCOPE_IDENTITY() else select 0
	end
	else
	begin
		Update WantAd set UserID=@UserID,AdType=@AdType,Instrument=@Instrument,Location=@Location,
		Direction=@Direction,Text=@Text,Title=@Title,Price=@price,Phone=@phone
		where AdID=@AdID
		select @@ROWCOUNT
	end
    
END


GO
/****** Object:  StoredProcedure [dbo].[WantAdSetMainImage]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdSetMainImage]
	@AdID int, @MediaID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Update WantAdMedia set IsMain = 0 where WantAdID = @adid

    Update WantAdMedia set IsMain = 1 where WantAdID = @adid and WantAdMediaID = @mediaID
	select @@ROWCOUNT
END


GO
/****** Object:  StoredProcedure [dbo].[WantAdsSearch]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdsSearch]
	@searchterm varchar(max),@adType int,@direction int, @userID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select * into #tmp from wantad where isactive = 1
	if @adType = 1000 -- recent ads on main page
	begin
		select top 7 * into #tmp2
		from #tmp
		order by DateCreated desc
		select	w.*, wm.Type,wm.DateCreated as MediaDateCreated, wm.IsMain,wm.Name,wm.WantAdID,wm.WantAdMediaID,wm.Url,wm.WantAdMediaDiskID
				from #tmp2 w
				left join wantadmedia wm
				on w.adid = wm.wantadID

		drop table #tmp
		drop table #tmp2
		return
	end

	set @searchterm = '%' + @searchterm + '%'
	declare @parent int
	select @parent = parent from wantadtype where wantadtypeid=@adtype

	if isnull(@searchterm,'') <> ''  delete from #tmp where (text not like @searchterm and title not like @searchterm)

	if @parent = 0 
	begin 
		delete from #tmp where adtype not in (select wantadtypeid from wantadtype where parent=@adtype)
	end
	if @parent <> 0 delete from #tmp where adtype <> @adtype
	if @userID > 0 delete from #tmp where userid <> @userid
	delete from #tmp where direction != @direction and @direction <> -1

	select	w.*, wm.Type,wm.DateCreated as MediaDateCreated, wm.IsMain,wm.Name,wm.WantAdID,wm.WantAdMediaID,wm.Url,wm.WantAdMediaDiskID
				from #tmp w
				left join wantadmedia wm
				on w.adid = wm.wantadID

	drop table #tmp
END


GO
/****** Object:  StoredProcedure [dbo].[WantAdTypeListLoad]    Script Date: 3/4/2016 1:18:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WantAdTypeListLoad]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select  * 
from    WantAdType feat
order by
        case 
        when Parent = 0 
        then Name 
        else    (
                select  Name 
                from    WantAdType parent 
                where   parent.WantAdTypeID = feat.Parent
                ) 
        end
,       case when Parent = 0 then 1 end desc
,       Name


END


GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'耘勅䁹⦃쓋ᱞʣ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'SongLookup' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'渰娝乾禐货ꨃƐ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'LookupType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'LookupType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'SongLookup' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupType'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'쾟斣䶮䑻➍�︸' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'LookupValue' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'LookupValue' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'SongLookup' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'LookupValue'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'쀿匯焙䂂ᢈ蘇뀦䞝' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Ordinal' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Ordinal' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'SongLookup' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackShade', @value=N'95' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackThemeColorIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'BackShade', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'BackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetForeThemeColorIndex', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetGridlinesThemeColorIndex', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'28/09/2013 8:47:42 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'DisplayViewsOnSharePointSite', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'09/08/2014 8:15:14 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderBy', @value=N'[SongLookup].[LookupValue], [SongLookup].[LookupType]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SongLookup' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'PublishToWeb', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'ReadOnlyWhenDisconnected', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'51' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'ThemeFontIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lookup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = month, 2 = year' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'PaymentPeriod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = GigMan, 2 = GigMan Request' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'PaymentContext'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-1 = rejected, 0 = pending, 1 = accepted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PendingJoinRequest', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'泃뢪見䄋ꚉ뇀≚' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'SetList' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'繆兺攢䂚₟翪΋ꞑ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SetName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SetName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'SetList' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SetName'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'嬋㶁렅䵙�ꭹ㐏⬚' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SetNumber' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SetNumber' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'SetList' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SubsetName'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'Ꮜ䏷鎅뀪遭' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Ordinal' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Ordinal' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'SetList' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'ﷶ袾榵䐕⾆㝎ѧ쇏' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SongTitle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SongTitle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'SetList' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackShade', @value=N'95' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackThemeColorIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'BackShade', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'BackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetForeThemeColorIndex', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetGridlinesThemeColorIndex', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'31/12/2013 10:28:35 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'DisplayViewsOnSharePointSite', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'27/07/2014 10:53:50 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SetList' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'PublishToWeb', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'ReadOnlyWhenDisconnected', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'328' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'ThemeFontIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SetList'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'765' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'⊐偡䤮乹䶚歔କꀢ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'1035' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'諾㜕ꑟ侬鎜䛜圻檁' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'UserID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'UserID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'2400' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'싫抨䃜뾿༭鴤' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'VerseColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'50' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'VerseColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'VerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'瑫ꃼ窋䊣ᒭ峍ӄ盤' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'AlternateVerseColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'AlternateVerseColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'AlternateVerseColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'쁮쓋Ｉ䪔ྐྵ袝用' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ChorusColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ChorusColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChorusColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'ᾘ㐚ɼ䍏㦒녌䂄얬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ChordsColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ChordsColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'節㊌⎛䉘쪋ማ䌻谌' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SongListsColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SongListsColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'׾�꣄丳躖볳엥틬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'LyricsFont' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'LyricsFont' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'苣拞㾌䂜⎓脋ഏ饗' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'LyricsFontSize' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'LyricsFontSize' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'凱偖텆䕣Ꚋｒ觢' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ChordsFont' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ChordsFont' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'ᬥ쿉赖亃춦璠滘漠' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ChordsFontSize' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ChordsFontSize' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'ChordsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'갻�쿭䌳掦녠사鼣' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SongListsFont' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'11' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SongListsFont' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'䢤辿갬俙窜⭬鶳煆' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SongListsFontSize' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SongListsFontSize' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'⑉섲髆䔼徾쳕譜ꆇ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'LyricsViewBackgroundColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'13' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'LyricsViewBackgroundColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'LyricsViewBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'ꝇꆈ䊉窭ൗ쩅☪' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SongListsBackgroundColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'14' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SongListsBackgroundColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'忈랦旑䩆殩࠻' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SongListsAlternateBackgroundColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'15' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SongListsAlternateBackgroundColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SongListsAlternateBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'븣숩￤䠯ن퀆_' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'HRSeperator' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'16' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'HRSeperator' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperator'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'཯�뮠䪽芹䉩⃑鲭' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'HRSeperatorColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'HRSeperatorColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'HRSeperatorColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'ꘚ�郵䈍傳펌⾙巨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SiteBackgroundColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'18' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SiteBackgroundColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteBackgroundColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'甶쐨俸䞂睊씝' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SiteTextColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'19' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SiteTextColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteTextColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'蔅숶�䉘⎃፜が鰔' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SiteFont' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'20' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SiteFont' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFont'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'ۇ�눔䅿蒕챵됐' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'IgnoreArticleSort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'21' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'IgnoreArticleSort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'IgnoreArticleSort'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'昊Ŝ䮉뺁뜼⹭ꂫ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'BridgeColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'22' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'BridgeColor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'BridgeColor'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'14' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'缈띐䁺亃랂僒鸯' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SiteFontSize' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'23' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SiteFontSize' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SiteFontSize'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'윮Ḓ䔴㾙䓎箅睖' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'SuperscriptChords' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'24' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'SuperscriptChords' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings', @level2type=N'COLUMN',@level2name=N'SuperscriptChords'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackShade', @value=N'95' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackThemeColorIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'BackShade', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'BackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetForeThemeColorIndex', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetGridlinesThemeColorIndex', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'06/06/2014 6:39:38 PM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'DisplayViewsOnSharePointSite', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'03/08/2014 9:06:44 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'PublishToWeb', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'ReadOnlyWhenDisconnected', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'ThemeFontIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'㍔鳙分䛕枭㟼擋㖩' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'SongID'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'3015' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'論䐁෬䦒枝䳌擂ằ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'㍏⢱�䛇螲냱읷' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Lyrics' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Lyrics' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'TextFormat', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Lyrics'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'츕�휔䅑瞋呃꥾㶰' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Tempo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Tempo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Tempo'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'1035' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'ལД瓣䍾᪊䕻啵麂' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Chords' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Chords' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'TextFormat', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'畢᧥꼞䄭膲٭ផ↚' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Genre' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Genre' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Genre'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'2970' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'�茁⅚䌯㮴訉' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Artist' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Artist' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Artist'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'戍䙅좨䕘Ꞣ䅿泌' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Familiarity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Familiarity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Familiarity'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'ิ贾倔䙿뢊벴䮞' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'駏䭿䉢랿☖໛呬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Sample' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'11' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Sample' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'Sample'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'壒攻䆌澩ㅋ쭞' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'UserID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'UserID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song', @level2type=N'COLUMN',@level2name=N'ArtistID'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackShade', @value=N'95' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackThemeColorIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'BackShade', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'BackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetForeThemeColorIndex', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetGridlinesThemeColorIndex', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'21/09/2013 11:57:01 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'DisplayViewsOnSharePointSite', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'28/09/2014 10:05:51 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Song' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'PublishToWeb', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'ReadOnlyWhenDisconnected', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'265' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'ThemeFontIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Song'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'舊䧸墥藝脓' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserID'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'㑝날쥹䋐殫ຖ骘ࡠ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'UserName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'UserName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'㞒癜䧴綼菆�蘫' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Password' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Password' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'紞ꗷ䊣陚냹แ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'焥ﾼិ䋅�벿亀坜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Active'
GO
EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'CurrencyLCID', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'죔맇裲䍝�쿮駝�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'PaidDate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'ResultType', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'ShowDatePicker', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'PaidDate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PaidDate'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackShade', @value=N'95' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackThemeColorIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'AlternateBackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'BackShade', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'BackTint', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetForeThemeColorIndex', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'DatasheetGridlinesThemeColorIndex', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'05/07/2014 9:47:04 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'DisplayViewsOnSharePointSite', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'13/09/2014 9:50:26 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'PublishToWeb', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'ReadOnlyWhenDisconnected', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'ThemeFontIndex', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
USE [master]
GO
ALTER DATABASE [GigMan] SET  READ_WRITE 
GO
