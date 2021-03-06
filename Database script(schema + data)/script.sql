/****** Object:  Database [BankManagementSys]    Script Date: 1/18/2021 5:12:17 PM ******/
CREATE DATABASE [BankManagementSys]  (EDITION = 'Basic', SERVICE_OBJECTIVE = 'Basic', MAXSIZE = 2 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS;
GO
ALTER DATABASE [BankManagementSys] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [BankManagementSys] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BankManagementSys] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BankManagementSys] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BankManagementSys] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BankManagementSys] SET ARITHABORT OFF 
GO
ALTER DATABASE [BankManagementSys] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BankManagementSys] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BankManagementSys] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BankManagementSys] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BankManagementSys] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BankManagementSys] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BankManagementSys] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BankManagementSys] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BankManagementSys] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [BankManagementSys] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BankManagementSys] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [BankManagementSys] SET  MULTI_USER 
GO
ALTER DATABASE [BankManagementSys] SET ENCRYPTION ON
GO
ALTER DATABASE [BankManagementSys] SET QUERY_STORE = ON
GO
ALTER DATABASE [BankManagementSys] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 7), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 10, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_diagramobjects]    Script Date: 1/18/2021 5:12:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE FUNCTION [dbo].[fn_diagramobjects]() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
	
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 1/18/2021 5:12:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OpenDate] [date] NOT NULL,
	[UserId] [int] NOT NULL,
	[Balance] [decimal](18, 2) NOT NULL,
	[Interest] [decimal](4, 2) NULL,
	[MonthlyFee] [decimal](5, 2) NULL,
	[AccountTypeId] [int] NOT NULL,
	[CloseDate] [date] NULL,
	[IsActive] [bit] NOT NULL,
	[InterestFeeDate]  AS (dateadd(month,datediff(month,[OpenDate],getdate())+(1),[OpenDate])),
 CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountTypes]    Script Date: 1/18/2021 5:12:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_AccountTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Logins]    Script Date: 1/18/2021 5:12:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Logins](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](20) NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_Logins] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 1/18/2021 5:12:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 1/18/2021 5:12:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[ToAccount] [int] NULL,
	[Type] [nvarchar](20) NOT NULL,
	[PaymentCategory] [nvarchar](20) NULL,
	[AccountId] [int] NOT NULL,
 CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 1/18/2021 5:12:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](20) NOT NULL,
	[MiddleName] [nvarchar](20) NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[Gender] [nvarchar](10) NOT NULL,
	[NationalId] [nvarchar](20) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[PhoneNo] [nvarchar](15) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[City] [nvarchar](20) NOT NULL,
	[ProvinceState] [nvarchar](20) NULL,
	[PostalCode] [nvarchar](10) NOT NULL,
	[Country] [nvarchar](20) NOT NULL,
	[Email] [nvarchar](60) NULL,
	[CompanyName] [nvarchar](70) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserTypes]    Script Date: 1/18/2021 5:12:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_UserTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Accounts] ON 

INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (1, CAST(N'2020-12-21' AS Date), 2, CAST(982372.60 AS Decimal(18, 2)), NULL, CAST(6.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (2, CAST(N'2020-12-19' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(4, 2)), NULL, 2, CAST(N'2021-01-12' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (3, CAST(N'2020-12-20' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(4.00 AS Decimal(5, 2)), 1, CAST(N'2021-01-12' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (15, CAST(N'2020-12-25' AS Date), 6, CAST(2981.95 AS Decimal(18, 2)), NULL, CAST(50.00 AS Decimal(5, 2)), 4, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (17, CAST(N'2017-10-19' AS Date), 2, CAST(9.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (18, CAST(N'2020-07-19' AS Date), 2, CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (19, CAST(N'2021-01-07' AS Date), 4, CAST(884.10 AS Decimal(18, 2)), NULL, CAST(4.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (20, CAST(N'2021-01-07' AS Date), 4, CAST(12.58 AS Decimal(18, 2)), CAST(1.25 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (21, CAST(N'2021-01-07' AS Date), 4, CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(4, 2)), NULL, 3, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (22, CAST(N'2021-01-07' AS Date), 4, CAST(0.00 AS Decimal(18, 2)), CAST(0.50 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (23, CAST(N'2021-01-07' AS Date), 4, CAST(0.00 AS Decimal(18, 2)), CAST(1.30 AS Decimal(4, 2)), NULL, 3, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (24, CAST(N'2021-01-07' AS Date), 7, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(10.00 AS Decimal(5, 2)), 1, CAST(N'2021-01-17' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (25, CAST(N'2021-01-07' AS Date), 3, CAST(470.00 AS Decimal(18, 2)), CAST(5.00 AS Decimal(4, 2)), NULL, 2, CAST(N'2021-01-18' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (26, CAST(N'2021-01-07' AS Date), 8, CAST(426.00 AS Decimal(18, 2)), NULL, CAST(10.00 AS Decimal(5, 2)), 4, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (27, CAST(N'2021-01-07' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), CAST(1.20 AS Decimal(4, 2)), NULL, 2, CAST(N'2021-01-12' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (31, CAST(N'2021-01-07' AS Date), 15, CAST(257.99 AS Decimal(18, 2)), NULL, CAST(10.00 AS Decimal(5, 2)), 4, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (32, CAST(N'2021-01-07' AS Date), 10, CAST(623.87 AS Decimal(18, 2)), NULL, CAST(20.00 AS Decimal(5, 2)), 4, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (33, CAST(N'2021-01-07' AS Date), 11, CAST(850.55 AS Decimal(18, 2)), NULL, CAST(10.00 AS Decimal(5, 2)), 4, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (34, CAST(N'2021-01-07' AS Date), 12, CAST(1205.88 AS Decimal(18, 2)), NULL, CAST(10.00 AS Decimal(5, 2)), 4, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (35, CAST(N'2021-01-08' AS Date), 2, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(12.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (36, CAST(N'2021-01-08' AS Date), 2, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(12.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (37, CAST(N'2021-01-08' AS Date), 2, CAST(9900.00 AS Decimal(18, 2)), CAST(1.50 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (38, CAST(N'2021-01-08' AS Date), 4, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(4.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (39, CAST(N'2021-01-08' AS Date), 4, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(12.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (40, CAST(N'2021-01-08' AS Date), 4, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(4.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (41, CAST(N'2021-01-08' AS Date), 4, CAST(225.60 AS Decimal(18, 2)), NULL, CAST(4.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (42, CAST(N'2021-01-08' AS Date), 5, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(5.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (43, CAST(N'2021-01-09' AS Date), 3, CAST(6210.72 AS Decimal(18, 2)), NULL, CAST(5.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (44, CAST(N'2021-01-10' AS Date), 5, CAST(280.00 AS Decimal(18, 2)), CAST(13.00 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (46, CAST(N'2021-01-10' AS Date), 5, CAST(500.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(4, 2)), NULL, 3, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (48, CAST(N'2021-01-12' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(13.00 AS Decimal(5, 2)), 1, CAST(N'2021-01-18' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (49, CAST(N'2021-01-12' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), CAST(2.00 AS Decimal(4, 2)), NULL, 3, CAST(N'2021-01-18' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (50, CAST(N'2021-01-12' AS Date), 3, CAST(371.00 AS Decimal(18, 2)), NULL, CAST(19.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (51, CAST(N'2021-01-12' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (52, CAST(N'2021-01-12' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(17.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (53, CAST(N'2021-01-12' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(14.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (54, CAST(N'2021-01-12' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(4, 2)), NULL, 3, CAST(N'2021-01-14' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (55, CAST(N'2021-01-14' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), CAST(6.00 AS Decimal(4, 2)), NULL, 3, CAST(N'2021-01-16' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (56, CAST(N'2021-01-16' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(10.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (57, CAST(N'2021-01-16' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(23.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (58, CAST(N'2021-01-16' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), CAST(8.00 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (59, CAST(N'2021-01-16' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(4.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (60, CAST(N'2021-01-16' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(6.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (61, CAST(N'2021-01-16' AS Date), 28, CAST(49677.37 AS Decimal(18, 2)), NULL, CAST(50.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (62, CAST(N'2021-01-16' AS Date), 28, CAST(24975.00 AS Decimal(18, 2)), CAST(1.25 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (63, CAST(N'2021-01-17' AS Date), 28, CAST(0.00 AS Decimal(18, 2)), CAST(0.50 AS Decimal(4, 2)), NULL, 2, CAST(N'2021-01-17' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (64, CAST(N'2020-11-23' AS Date), 30, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(4.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (65, CAST(N'2020-11-23' AS Date), 30, CAST(0.00 AS Decimal(18, 2)), CAST(0.50 AS Decimal(4, 2)), NULL, 2, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (66, CAST(N'2021-01-17' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(10.00 AS Decimal(5, 2)), 1, NULL, 1)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (67, CAST(N'2021-01-17' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(5.00 AS Decimal(5, 2)), 1, CAST(N'2021-01-17' AS Date), 0)
INSERT [dbo].[Accounts] ([Id], [OpenDate], [UserId], [Balance], [Interest], [MonthlyFee], [AccountTypeId], [CloseDate], [IsActive]) VALUES (68, CAST(N'2021-01-18' AS Date), 3, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(5.00 AS Decimal(5, 2)), 1, NULL, 1)
SET IDENTITY_INSERT [dbo].[Accounts] OFF
GO
SET IDENTITY_INSERT [dbo].[AccountTypes] ON 

INSERT [dbo].[AccountTypes] ([Id], [Description]) VALUES (1, N'Checking')
INSERT [dbo].[AccountTypes] ([Id], [Description]) VALUES (2, N'Savings')
INSERT [dbo].[AccountTypes] ([Id], [Description]) VALUES (3, N'Investment')
INSERT [dbo].[AccountTypes] ([Id], [Description]) VALUES (4, N'Business')
SET IDENTITY_INSERT [dbo].[AccountTypes] OFF
GO
SET IDENTITY_INSERT [dbo].[Logins] ON 

INSERT [dbo].[Logins] ([Id], [Username], [Password], [UserTypeId], [UserId]) VALUES (2, N'Saulo', N'qwerty123', 2, 2)
INSERT [dbo].[Logins] ([Id], [Username], [Password], [UserTypeId], [UserId]) VALUES (3, N'Viriato', N'qwerty123', 3, 3)
INSERT [dbo].[Logins] ([Id], [Username], [Password], [UserTypeId], [UserId]) VALUES (4, N'Jose', N'qwerty123', 3, 7)
INSERT [dbo].[Logins] ([Id], [Username], [Password], [UserTypeId], [UserId]) VALUES (7, N'Aristoteles', N'qwerty123', 3, 12)
INSERT [dbo].[Logins] ([Id], [Username], [Password], [UserTypeId], [UserId]) VALUES (8, N'Martha', N'qwerty123', 3, 22)
INSERT [dbo].[Logins] ([Id], [Username], [Password], [UserTypeId], [UserId]) VALUES (9, N'JohnAbbott', N'qwerty123', 3, 28)
INSERT [dbo].[Logins] ([Id], [Username], [Password], [UserTypeId], [UserId]) VALUES (11, N'Thomas', N'qwerty123', 3, 30)
SET IDENTITY_INSERT [dbo].[Logins] OFF
GO
SET IDENTITY_INSERT [dbo].[Transactions] ON 

INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (1, CAST(N'2020-12-20' AS Date), CAST(30.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (2, CAST(N'2020-12-21' AS Date), CAST(45.20 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (3, CAST(N'2020-12-21' AS Date), CAST(50.37 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (4, CAST(N'2020-12-22' AS Date), CAST(89.97 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (5, CAST(N'2020-09-10' AS Date), CAST(23.89 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (6, CAST(N'2020-12-15' AS Date), CAST(56.89 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (7, CAST(N'2020-11-15' AS Date), CAST(12.35 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (8, CAST(N'2020-12-23' AS Date), CAST(20.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (9, CAST(N'2020-12-23' AS Date), CAST(2.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (10, CAST(N'2020-12-23' AS Date), CAST(2.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (11, CAST(N'2020-12-23' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (12, CAST(N'2020-12-23' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (13, CAST(N'2020-12-23' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (14, CAST(N'2020-12-23' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (15, CAST(N'2020-12-23' AS Date), CAST(20.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (16, CAST(N'2020-12-24' AS Date), CAST(20.00 AS Decimal(18, 2)), 2, N'Transfer', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (17, CAST(N'2020-12-24' AS Date), CAST(10.00 AS Decimal(18, 2)), 2, N'Transfer', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (18, CAST(N'2020-12-24' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (19, CAST(N'2020-12-24' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (20, CAST(N'2020-12-24' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (21, CAST(N'2020-12-24' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (22, CAST(N'2020-12-24' AS Date), CAST(120.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (23, CAST(N'2020-12-24' AS Date), CAST(5.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (24, CAST(N'2020-12-24' AS Date), CAST(2.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (25, CAST(N'2020-12-24' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (26, CAST(N'2020-12-24' AS Date), CAST(5.60 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (27, CAST(N'2020-12-24' AS Date), CAST(2.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (28, CAST(N'2020-12-24' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (29, CAST(N'2020-12-24' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (30, CAST(N'2020-12-24' AS Date), CAST(2.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (31, CAST(N'2020-12-24' AS Date), CAST(5.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (32, CAST(N'2020-12-24' AS Date), CAST(5.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (33, CAST(N'2020-12-24' AS Date), CAST(2.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (34, CAST(N'2020-12-24' AS Date), CAST(2.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (35, CAST(N'2020-12-24' AS Date), CAST(34.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (36, CAST(N'2020-12-24' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (37, CAST(N'2020-12-24' AS Date), CAST(250.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (38, CAST(N'2020-12-24' AS Date), CAST(45.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (39, CAST(N'2020-12-24' AS Date), CAST(12.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (40, CAST(N'2020-12-24' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (41, CAST(N'2020-12-24' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (42, CAST(N'2020-12-24' AS Date), CAST(1000.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (43, CAST(N'2020-12-25' AS Date), CAST(2000.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (44, CAST(N'2020-12-25' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (45, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (46, CAST(N'2020-12-25' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (47, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (48, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (49, CAST(N'2020-12-25' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (50, CAST(N'2020-12-25' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (51, CAST(N'2020-12-25' AS Date), CAST(30.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (52, CAST(N'2020-12-25' AS Date), CAST(30.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (53, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (54, CAST(N'2020-12-25' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (55, CAST(N'2020-12-25' AS Date), CAST(15.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (56, CAST(N'2020-12-25' AS Date), CAST(10.50 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (57, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (58, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (59, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (60, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), 2, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (61, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (62, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (63, CAST(N'2020-12-25' AS Date), CAST(13.20 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (64, CAST(N'2020-12-25' AS Date), CAST(15.90 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (65, CAST(N'2020-12-25' AS Date), CAST(12.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (66, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (67, CAST(N'2020-12-25' AS Date), CAST(200.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (68, CAST(N'2020-12-25' AS Date), CAST(100.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (69, CAST(N'2020-12-25' AS Date), CAST(56.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (70, CAST(N'2020-12-25' AS Date), CAST(50.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (71, CAST(N'2020-12-25' AS Date), CAST(12.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (72, CAST(N'2020-12-25' AS Date), CAST(25.36 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (73, CAST(N'2020-12-25' AS Date), CAST(12.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (74, CAST(N'2020-12-25' AS Date), CAST(10.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (75, CAST(N'2020-12-25' AS Date), CAST(12.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (76, CAST(N'2020-12-25' AS Date), CAST(120.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (77, CAST(N'2020-12-25' AS Date), CAST(200.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (78, CAST(N'2020-12-25' AS Date), CAST(15.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (79, CAST(N'2020-12-26' AS Date), CAST(215.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (80, CAST(N'2020-12-26' AS Date), CAST(98.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (81, CAST(N'2020-12-26' AS Date), CAST(65.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (82, CAST(N'2020-12-26' AS Date), CAST(2.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (83, CAST(N'2020-12-26' AS Date), CAST(12.30 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (84, CAST(N'2020-12-26' AS Date), CAST(12.90 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (85, CAST(N'2020-12-26' AS Date), CAST(13.40 AS Decimal(18, 2)), 2, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (86, CAST(N'2020-12-26' AS Date), CAST(26.40 AS Decimal(18, 2)), 2, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (87, CAST(N'2020-12-26' AS Date), CAST(25.85 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (88, CAST(N'2020-12-26' AS Date), CAST(17.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (89, CAST(N'2020-12-26' AS Date), CAST(300.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (90, CAST(N'2020-12-26' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (92, CAST(N'2020-12-26' AS Date), CAST(0.30 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (93, CAST(N'2020-12-26' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (94, CAST(N'2020-12-26' AS Date), CAST(1300.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (95, CAST(N'2020-12-26' AS Date), CAST(200.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (96, CAST(N'2020-12-26' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (97, CAST(N'2020-12-26' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (99, CAST(N'2020-12-26' AS Date), CAST(3.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (102, CAST(N'2020-12-26' AS Date), CAST(1.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (104, CAST(N'2020-09-10' AS Date), CAST(13.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 18)
GO
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (105, CAST(N'2020-10-10' AS Date), CAST(103.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 18)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (106, CAST(N'2021-01-06' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (107, CAST(N'2021-01-06' AS Date), CAST(2.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (108, CAST(N'2021-01-06' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (109, CAST(N'2021-01-06' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (110, CAST(N'2021-01-06' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (111, CAST(N'2021-01-06' AS Date), CAST(1.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (112, CAST(N'2021-01-06' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (113, CAST(N'2021-01-06' AS Date), CAST(63.50 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (114, CAST(N'2021-01-06' AS Date), CAST(10.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (115, CAST(N'2021-01-06' AS Date), CAST(0.10 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (116, CAST(N'2021-01-06' AS Date), CAST(120.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (117, CAST(N'2021-01-07' AS Date), CAST(10.00 AS Decimal(18, 2)), 3, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (118, CAST(N'2021-01-07' AS Date), CAST(10.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (119, CAST(N'2021-01-07' AS Date), CAST(5.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (120, CAST(N'2021-01-07' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (121, CAST(N'2021-01-07' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (122, CAST(N'2021-01-07' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (123, CAST(N'2021-01-07' AS Date), CAST(250000.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (124, CAST(N'2021-01-07' AS Date), CAST(2000.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (125, CAST(N'2021-01-07' AS Date), CAST(100000.00 AS Decimal(18, 2)), 2, N'Transfer', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (126, CAST(N'2021-01-07' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (128, CAST(N'2021-01-07' AS Date), CAST(120.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (129, CAST(N'2021-01-07' AS Date), CAST(1000.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (130, CAST(N'2021-01-07' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (131, CAST(N'2021-01-07' AS Date), CAST(550.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (132, CAST(N'2021-01-07' AS Date), CAST(10.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (133, CAST(N'2021-01-07' AS Date), CAST(550.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (134, CAST(N'2021-01-07' AS Date), CAST(550.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (135, CAST(N'2021-01-07' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (136, CAST(N'2021-01-07' AS Date), CAST(50.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (137, CAST(N'2021-01-07' AS Date), CAST(25.00 AS Decimal(18, 2)), 2, N'Transfer', NULL, 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (138, CAST(N'2021-01-07' AS Date), CAST(12.50 AS Decimal(18, 2)), 26, N'Payment', N'Other', 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (139, CAST(N'2021-01-07' AS Date), CAST(94.10 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 3)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (140, CAST(N'2021-01-07' AS Date), CAST(99179.01 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (141, CAST(N'2021-01-07' AS Date), CAST(36.00 AS Decimal(18, 2)), 34, N'Payment', N'Education', 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (142, CAST(N'2021-01-08' AS Date), CAST(5000.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 17)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (143, CAST(N'2021-01-08' AS Date), CAST(876.50 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (144, CAST(N'2021-01-08' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 24)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (145, CAST(N'2021-01-08' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 24)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (146, CAST(N'2021-01-08' AS Date), CAST(10000.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 18)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (147, CAST(N'2021-01-08' AS Date), CAST(200.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 39)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (148, CAST(N'2021-01-08' AS Date), CAST(200.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 39)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (149, CAST(N'2021-01-08' AS Date), CAST(200.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 40)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (150, CAST(N'2021-01-08' AS Date), CAST(200.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 40)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (151, CAST(N'2021-01-08' AS Date), CAST(200.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 41)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (152, CAST(N'2021-01-08' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (153, CAST(N'2021-01-08' AS Date), CAST(200.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (154, CAST(N'2021-01-08' AS Date), CAST(10.00 AS Decimal(18, 2)), 2, N'Transfer', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (155, CAST(N'2021-01-09' AS Date), CAST(10000.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (156, CAST(N'2021-01-09' AS Date), CAST(10.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (157, CAST(N'2021-01-09' AS Date), CAST(20.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (158, CAST(N'2021-01-09' AS Date), CAST(50.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (159, CAST(N'2021-01-09' AS Date), CAST(50.00 AS Decimal(18, 2)), 34, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (160, CAST(N'2021-01-09' AS Date), CAST(13.00 AS Decimal(18, 2)), 34, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (161, CAST(N'2021-01-09' AS Date), CAST(180.00 AS Decimal(18, 2)), 33, N'Payment', N'Utility bills', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (173, CAST(N'2021-01-10' AS Date), CAST(25.00 AS Decimal(18, 2)), 19, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (174, CAST(N'2021-01-10' AS Date), CAST(58.25 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (178, CAST(N'2021-01-10' AS Date), CAST(12.58 AS Decimal(18, 2)), 20, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (179, CAST(N'2021-01-10' AS Date), CAST(115.99 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (180, CAST(N'2021-01-10' AS Date), CAST(300.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 44)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (181, CAST(N'2021-01-10' AS Date), CAST(20.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 44)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (185, CAST(N'2021-01-10' AS Date), CAST(13.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (190, CAST(N'2021-01-10' AS Date), CAST(13.69 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (192, CAST(N'2021-01-10' AS Date), CAST(12.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (198, CAST(N'2021-01-10' AS Date), CAST(50.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (210, CAST(N'2021-01-10' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (211, CAST(N'2021-01-10' AS Date), CAST(30.00 AS Decimal(18, 2)), 15, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (212, CAST(N'2021-01-10' AS Date), CAST(15.00 AS Decimal(18, 2)), 26, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (213, CAST(N'2021-01-10' AS Date), CAST(12.36 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (215, CAST(N'2021-01-10' AS Date), CAST(98.00 AS Decimal(18, 2)), 33, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (216, CAST(N'2021-01-10' AS Date), CAST(34.00 AS Decimal(18, 2)), 26, N'Payment', N'Utility bills', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (217, CAST(N'2021-01-10' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (218, CAST(N'2021-01-10' AS Date), CAST(25.36 AS Decimal(18, 2)), 31, N'Payment', N'Other', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (219, CAST(N'2021-01-10' AS Date), CAST(25.58 AS Decimal(18, 2)), 34, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (226, CAST(N'2021-01-10' AS Date), CAST(78.00 AS Decimal(18, 2)), 34, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (227, CAST(N'2021-01-10' AS Date), CAST(12.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (228, CAST(N'2021-01-10' AS Date), CAST(57.00 AS Decimal(18, 2)), 34, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (232, CAST(N'2021-01-10' AS Date), CAST(500.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 46)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (233, CAST(N'2021-01-10' AS Date), CAST(20.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (234, CAST(N'2021-01-10' AS Date), CAST(60.00 AS Decimal(18, 2)), 33, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (237, CAST(N'2021-01-11' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (238, CAST(N'2021-01-11' AS Date), CAST(30.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (239, CAST(N'2021-01-11' AS Date), CAST(40.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (240, CAST(N'2021-01-11' AS Date), CAST(46.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (242, CAST(N'2021-01-11' AS Date), CAST(80.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (244, CAST(N'2021-01-11' AS Date), CAST(100.00 AS Decimal(18, 2)), 34, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (245, CAST(N'2021-01-11' AS Date), CAST(90.00 AS Decimal(18, 2)), 34, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (246, CAST(N'2021-01-11' AS Date), CAST(90.00 AS Decimal(18, 2)), 26, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (247, CAST(N'2021-01-11' AS Date), CAST(90.00 AS Decimal(18, 2)), 26, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (248, CAST(N'2021-01-11' AS Date), CAST(80.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (250, CAST(N'2021-01-11' AS Date), CAST(90.00 AS Decimal(18, 2)), 15, N'Payment', N'Utility bills', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (251, CAST(N'2021-01-11' AS Date), CAST(10.00 AS Decimal(18, 2)), 32, N'Payment', N'Utility bills', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (252, CAST(N'2021-01-11' AS Date), CAST(80.00 AS Decimal(18, 2)), 31, N'Payment', N'Utility bills', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (258, CAST(N'2021-01-11' AS Date), CAST(90.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (261, CAST(N'2021-01-11' AS Date), CAST(100.00 AS Decimal(18, 2)), 32, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (265, CAST(N'2021-01-11' AS Date), CAST(90.00 AS Decimal(18, 2)), 32, N'Payment', N'Groceries', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (266, CAST(N'2021-01-11' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (267, CAST(N'2021-01-11' AS Date), CAST(100.00 AS Decimal(18, 2)), 26, N'Payment', N'Utility bills', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (268, CAST(N'2021-01-11' AS Date), CAST(100.00 AS Decimal(18, 2)), 32, N'Payment', N'Groceries', 43)
GO
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (269, CAST(N'2021-01-11' AS Date), CAST(200.00 AS Decimal(18, 2)), 33, N'Payment', N'Leisure', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (270, CAST(N'2021-01-11' AS Date), CAST(78.00 AS Decimal(18, 2)), 31, N'Payment', N'Government', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (271, CAST(N'2021-01-11' AS Date), CAST(90.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (272, CAST(N'2021-01-11' AS Date), CAST(100.00 AS Decimal(18, 2)), 32, N'Payment', N'Groceries', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (273, CAST(N'2021-01-11' AS Date), CAST(90.00 AS Decimal(18, 2)), 33, N'Payment', N'Other', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (274, CAST(N'2021-01-11' AS Date), CAST(36.58 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (275, CAST(N'2021-01-11' AS Date), CAST(14.50 AS Decimal(18, 2)), 26, N'Payment', N'Leisure', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (276, CAST(N'2021-01-11' AS Date), CAST(24.87 AS Decimal(18, 2)), 32, N'Payment', N'Groceries', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (277, CAST(N'2021-01-11' AS Date), CAST(50.25 AS Decimal(18, 2)), 33, N'Payment', N'Groceries', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (278, CAST(N'2021-01-11' AS Date), CAST(58.90 AS Decimal(18, 2)), 34, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (279, CAST(N'2021-01-11' AS Date), CAST(32.65 AS Decimal(18, 2)), 31, N'Payment', N'Other', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (280, CAST(N'2021-01-12' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (281, CAST(N'2021-01-12' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (282, CAST(N'2021-01-12' AS Date), CAST(2.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (283, CAST(N'2021-01-12' AS Date), CAST(8.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (284, CAST(N'2021-01-12' AS Date), CAST(300.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (285, CAST(N'2021-01-14' AS Date), CAST(78.00 AS Decimal(18, 2)), 15, N'Payment', N'Utility bills', 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (286, CAST(N'2021-01-14' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (287, CAST(N'2021-01-14' AS Date), CAST(9.00 AS Decimal(18, 2)), 17, N'Transfer', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (288, CAST(N'2021-01-15' AS Date), CAST(60000.00 AS Decimal(18, 2)), 2, N'Transfer', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (289, CAST(N'2021-01-15' AS Date), CAST(100000.00 AS Decimal(18, 2)), 3, N'Transfer', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (290, CAST(N'2021-01-15' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 55)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (291, CAST(N'2021-01-15' AS Date), CAST(10000.00 AS Decimal(18, 2)), 37, N'Transfer', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (292, CAST(N'2021-01-15' AS Date), CAST(10000.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 37)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (293, CAST(N'2021-01-15' AS Date), CAST(100.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 37)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (294, CAST(N'2021-01-15' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (295, CAST(N'2021-01-15' AS Date), CAST(570.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (296, CAST(N'2021-01-15' AS Date), CAST(570.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (297, CAST(N'2021-01-16' AS Date), CAST(1.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (298, CAST(N'2021-01-16' AS Date), CAST(1.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (299, CAST(N'2021-01-16' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (300, CAST(N'2021-01-16' AS Date), CAST(500.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (301, CAST(N'2021-01-16' AS Date), CAST(500.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 50)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (302, CAST(N'2021-01-16' AS Date), CAST(400.00 AS Decimal(18, 2)), 15, N'Payment', N'Select category', 50)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (303, CAST(N'2021-01-16' AS Date), CAST(400.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (304, CAST(N'2021-01-16' AS Date), CAST(10.00 AS Decimal(18, 2)), 15, N'Payment', N'Select category', 50)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (305, CAST(N'2021-01-16' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (306, CAST(N'2021-01-16' AS Date), CAST(10.00 AS Decimal(18, 2)), 32, N'Payment', N'Groceries', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (307, CAST(N'2021-01-16' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 32)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (308, CAST(N'2021-01-16' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (309, CAST(N'2021-01-16' AS Date), CAST(50000.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (310, CAST(N'2021-01-16' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (311, CAST(N'2021-01-16' AS Date), CAST(25000.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 62)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (312, CAST(N'2021-01-16' AS Date), CAST(25.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 62)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (313, CAST(N'2021-01-16' AS Date), CAST(25.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (314, CAST(N'2021-01-16' AS Date), CAST(500.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (315, CAST(N'2021-01-16' AS Date), CAST(50.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (316, CAST(N'2021-01-16' AS Date), CAST(25.00 AS Decimal(18, 2)), 19, N'Transfer', NULL, 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (317, CAST(N'2021-01-16' AS Date), CAST(25.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (318, CAST(N'2021-01-16' AS Date), CAST(1000.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (319, CAST(N'2021-01-16' AS Date), CAST(25.00 AS Decimal(18, 2)), 61, N'Transfer', NULL, 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (320, CAST(N'2021-01-16' AS Date), CAST(25.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (321, CAST(N'2021-01-16' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 55)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (322, CAST(N'2021-01-16' AS Date), CAST(86.50 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (323, CAST(N'2021-01-16' AS Date), CAST(86.50 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (324, CAST(N'2021-01-16' AS Date), CAST(100.00 AS Decimal(18, 2)), 2, N'Transfer', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (325, CAST(N'2021-01-16' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 2)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (326, CAST(N'2021-01-16' AS Date), CAST(20.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (327, CAST(N'2021-01-16' AS Date), CAST(20.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (328, CAST(N'2021-01-16' AS Date), CAST(120.90 AS Decimal(18, 2)), 34, N'Payment', N'Education', 19)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (329, CAST(N'2021-01-16' AS Date), CAST(120.90 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 34)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (330, CAST(N'2021-01-17' AS Date), CAST(520.50 AS Decimal(18, 2)), 34, N'Payment', N'Education', 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (331, CAST(N'2021-01-17' AS Date), CAST(520.50 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 34)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (332, CAST(N'2021-01-17' AS Date), CAST(41.98 AS Decimal(18, 2)), 31, N'Payment', N'Other', 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (333, CAST(N'2021-01-17' AS Date), CAST(41.98 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 31)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (334, CAST(N'2021-01-17' AS Date), CAST(23.65 AS Decimal(18, 2)), 33, N'Payment', N'Leisure', 61)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (335, CAST(N'2021-01-17' AS Date), CAST(23.65 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 33)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (336, CAST(N'2021-01-17' AS Date), CAST(148.65 AS Decimal(18, 2)), 33, N'Payment', N'Groceries', 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (337, CAST(N'2021-01-17' AS Date), CAST(148.65 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 33)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (338, CAST(N'2020-11-24' AS Date), CAST(2000.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 64)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (339, CAST(N'2020-11-24' AS Date), CAST(500.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 65)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (340, CAST(N'2021-01-17' AS Date), CAST(19.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 50)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (341, CAST(N'2021-01-17' AS Date), CAST(19.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (342, CAST(N'2021-01-17' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (343, CAST(N'2021-01-17' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (344, CAST(N'2021-01-17' AS Date), CAST(60.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (345, CAST(N'2021-01-17' AS Date), CAST(60.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (346, CAST(N'2021-01-17' AS Date), CAST(50.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 50)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (347, CAST(N'2021-01-17' AS Date), CAST(50.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (348, CAST(N'2021-01-17' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Withdrawal', NULL, 50)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (349, CAST(N'2021-01-17' AS Date), CAST(500.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 50)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (350, CAST(N'2021-01-18' AS Date), CAST(100.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 50)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (351, CAST(N'2021-01-18' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (352, CAST(N'2021-01-18' AS Date), CAST(40.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 50)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (353, CAST(N'2021-01-18' AS Date), CAST(40.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (354, CAST(N'2021-01-18' AS Date), CAST(25.60 AS Decimal(18, 2)), 41, N'Transfer', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (355, CAST(N'2021-01-18' AS Date), CAST(25.60 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 41)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (356, CAST(N'2021-01-18' AS Date), CAST(25.50 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (357, CAST(N'2021-01-18' AS Date), CAST(25.50 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (358, CAST(N'2021-01-18' AS Date), CAST(70.00 AS Decimal(18, 2)), 26, N'Payment', N'Groceries', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (359, CAST(N'2021-01-18' AS Date), CAST(70.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 26)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (360, CAST(N'2021-01-18' AS Date), CAST(89.00 AS Decimal(18, 2)), 32, N'Payment', N'Groceries', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (361, CAST(N'2021-01-18' AS Date), CAST(89.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 32)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (362, CAST(N'2021-01-18' AS Date), CAST(56.00 AS Decimal(18, 2)), 34, N'Payment', N'Education', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (363, CAST(N'2021-01-18' AS Date), CAST(56.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 34)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (364, CAST(N'2021-01-18' AS Date), CAST(105.36 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (365, CAST(N'2021-01-18' AS Date), CAST(105.36 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (366, CAST(N'2021-01-18' AS Date), CAST(100.00 AS Decimal(18, 2)), 32, N'Payment', N'Groceries', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (367, CAST(N'2021-01-18' AS Date), CAST(100.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 32)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (368, CAST(N'2021-01-18' AS Date), CAST(500.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 25)
GO
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (369, CAST(N'2021-01-18' AS Date), CAST(30.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 25)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (370, CAST(N'2021-01-18' AS Date), CAST(30.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (371, CAST(N'2021-01-18' AS Date), CAST(136.36 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (372, CAST(N'2021-01-18' AS Date), CAST(136.36 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (373, CAST(N'2021-01-18' AS Date), CAST(10.00 AS Decimal(18, 2)), 1, N'Transfer', NULL, 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (374, CAST(N'2021-01-18' AS Date), CAST(10.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 1)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (375, CAST(N'2021-01-18' AS Date), CAST(60.00 AS Decimal(18, 2)), 15, N'Payment', N'Transportation', 43)
INSERT [dbo].[Transactions] ([Id], [Date], [Amount], [ToAccount], [Type], [PaymentCategory], [AccountId]) VALUES (376, CAST(N'2021-01-18' AS Date), CAST(60.00 AS Decimal(18, 2)), NULL, N'Deposit', NULL, 15)
SET IDENTITY_INSERT [dbo].[Transactions] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (2, N'Saulo Jose', N'Costa', N'Moreira', N'male', N'SM123456', CAST(N'1980-07-24' AS Date), N'514-908-9080', N'45 Rose Street', N'Montreal', N'QC', N'H6T4R5', N'Canada', N'saulomoreira@gmail.com', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (3, N'Viriato', N'Diablo', N'Chibata', N'male', N'VC123456', CAST(N'1954-08-12' AS Date), N'514-567-2569', N'3498 Madeira Street', N'Trois Revieres', N'QC', N'U78UI', N'Canada', N'ks.studilina@gmail.com', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (4, N'Zeca', N'', N'Gado', N'male', N'ZG123456', CAST(N'1979-02-06' AS Date), N'514-980-4534', N'51 Cattle St', N'Denver', N'CO', N'T5K8Y8', N'USA', N'', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (5, N'Ksenia', N'', N'Studilina', N'female', N'KS123456', CAST(N'1989-06-20' AS Date), N'514-098-8912', N'123 Snow St', N'Montreal', N'QC', N'H1T5R6', N'Canada', NULL, NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (6, N'Hanz', N'Paulo', N'Goretti', N'male', N'SQ123456', CAST(N'2012-09-10' AS Date), N'514-980-7878', N'675 Transcontinental St', N'Montreal', N'QC', N'H3E7T5', N'Canada', N'saaq@mail.ca', N'SAAQ')
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (7, N'Jose', NULL, N'Chibata', N'male', N'JC123456', CAST(N'1980-07-15' AS Date), N'514-398-0989', N'567 Trees Avenue', N'Montreal', N'QC', N'H6R7Y6', N'Canada', N'jchibata@gmail.com', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (8, N'Cava', N'Careca', N'Docura', N'female', N'CD123456', CAST(N'2015-05-08' AS Date), N'514-096-6756', N'4536 Cabelo St', N'Montreal', N'QC', N'H7T5O9', N'Canada', N'cava@mail.com', N'Cabeca')
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (9, N'Anna', N'Maria', N'Smith', N'other', N'AS123456', CAST(N'1964-07-23' AS Date), N'514-093-6756', N'342 Lilia Avenue', N'Toronto', N'ON', N'7I9Y6U', N'Canada', N'', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (10, N'Bruno', N'Pedaco', N'Mars', N'male', N'BM123456', CAST(N'2020-11-29' AS Date), N'534-987-5678', N'5678 Independence St', N'Hamilton', N'ON', N'T6R5I8', N'Canada', N'sugarhills@mail.com', N'Sugar hills')
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (11, N'Olegário', N'', N'Gregório', N'male', N'5896325', CAST(N'2020-12-27' AS Date), N'603-258-6987', N'5236 Market St', N'Toronto', N'ON', N'H9U 9T5', N'Canada', N'', N'Minuano LTD')
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (12, N'Aristóteles', N'', N'Estagira', N'male', N'58666', CAST(N'2020-12-27' AS Date), N'987-654-9588', N'5698 Philosophy St', N'Athens', N'ON', N'H9U F4E', N'Canada', N'TheAcademy@protonmail.com', N'Academy of Philosophy')
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (15, N'Alípio', N'', N'Martins', N'male', N'85632145', CAST(N'2018-05-15' AS Date), N'487-852-9536', N'75 Brega Rd.', N'Drummondville', N'QC', N'H8G9T5', N'Canada', N'', N'Optimum Inc.')
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (16, N'Ksenia', N'', N'Smith', N'Female', N'KS1234567', CAST(N'1989-07-13' AS Date), N'514-908-9090', N'567 Rose St', N'Montreal', N'QC', N'H7T6Y8', N'Canada', N'', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (21, N'Brena', N'', N'Johnson', N'Female', N'BJ123456', CAST(N'2020-10-12' AS Date), N'514-905-4545', N'456 Thompson Av', N'Ottawa', N'Ontario', N'H5T7M8', N'Canada', N'', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (22, N'Martha', N'', N'Lawson', N'Male', N'ML123456', CAST(N'2020-10-20' AS Date), N'789-908-9090', N'jhvjhjkshldls', N'sjkdsjk', N'ksdjfbsdjk', N'sjkdfsdjk', N'Canada', N'', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (28, N'John', N'', N'Abbott', N'male', N'JA123456', CAST(N'1971-03-18' AS Date), N'514-457-6610', N'21 275 Lakeshore Road', N'St-Anne-de-Bellevue', N'QC', N'H9X 3L9', N'Canada', N'jab.testingemail@gmail.com', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (30, N'Thomas', N'', N'Chapais', N'Male', N'TC123456', CAST(N'1974-07-30' AS Date), N'514-905-6789', N'5678 Magnolia St', N'Montreal', N'QC', N'H6R4O8', N'Canada', N'ks.studilina@gmail.com', NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [MiddleName], [LastName], [Gender], [NationalId], [DateOfBirth], [PhoneNo], [Address], [City], [ProvinceState], [PostalCode], [Country], [Email], [CompanyName]) VALUES (32, N'Thomas', N'', N'Tim', N'male', N'gh565656', CAST(N'2020-12-28' AS Date), N'908-908-9090', N'56 nfg st', N'Montreal', N'QC', N'H6T5R6', N'Canada', N'', NULL)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET IDENTITY_INSERT [dbo].[UserTypes] ON 

INSERT [dbo].[UserTypes] ([Id], [Description]) VALUES (1, N'admin')
INSERT [dbo].[UserTypes] ([Id], [Description]) VALUES (2, N'agent')
INSERT [dbo].[UserTypes] ([Id], [Description]) VALUES (3, N'client')
SET IDENTITY_INSERT [dbo].[UserTypes] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_principal_name]    Script Date: 1/18/2021 5:12:20 PM ******/
ALTER TABLE [dbo].[sysdiagrams] ADD  CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UC_NationalId]    Script Date: 1/18/2021 5:12:20 PM ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [UC_NationalId] UNIQUE NONCLUSTERED 
(
	[NationalId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountTypes] ([Id])
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Logins]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Logins]  WITH CHECK ADD FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UserTypes] ([Id])
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD FOREIGN KEY([AccountId])
REFERENCES [dbo].[Accounts] ([Id])
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD  CONSTRAINT [CHK_Interest] CHECK  (([Interest]>=(0)))
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [CHK_Interest]
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD  CONSTRAINT [CHK_MonthlyFee] CHECK  (([MonthlyFee]>=(0)))
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [CHK_MonthlyFee]
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [CHK_Amount] CHECK  (([Amount]>(0)))
GO
ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [CHK_Amount]
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [CHK_TransType] CHECK  (([Type]='Dividents' OR [Type]='Interest' OR [Type]='Monthly Fee' OR [Type]='Payment' OR [Type]='Transfer' OR [Type]='Withdrawal' OR [Type]='Deposit'))
GO
ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [CHK_TransType]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([Gender]='other' OR [Gender]='female' OR [Gender]='male'))
GO
/****** Object:  StoredProcedure [dbo].[sp_alterdiagram]    Script Date: 1/18/2021 5:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_alterdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_creatediagram]    Script Date: 1/18/2021 5:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_creatediagram]
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdiagram]    Script Date: 1/18/2021 5:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_dropdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagramdefinition]    Script Date: 1/18/2021 5:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagramdefinition]
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagrams]    Script Date: 1/18/2021 5:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagrams]
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_renamediagram]    Script Date: 1/18/2021 5:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_renamediagram]
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_upgraddiagrams]    Script Date: 1/18/2021 5:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_upgraddiagrams]
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
	
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sysdiagrams'
GO
ALTER DATABASE [BankManagementSys] SET  READ_WRITE 
GO
