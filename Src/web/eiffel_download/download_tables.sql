USE [example]
GO
/****** Object:  Table [dbo].[ContactsTemporary]    Script Date: 23/09/2014 9:00:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContactsTemporary](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](240) NULL,
	[LastName] [varchar](240) NULL,
	[Email] [varchar](150) NOT NULL,
	[Newsletter] [int] NULL,
 CONSTRAINT [PK_ContactsTemporary] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
) 
ON)  [PRIMARY],
 CONSTRAINT [UniqueEmail] UNIQUE NONCLUSTERED 
(
	[Email] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DownloadExpiration]    Script Date: 23/09/2014 9:00:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DownloadExpiration](
	[ContactID] [int] NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[Token] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Platform] [varchar](50) NOT NULL,
	[FirstName] [varchar](240) NULL,
	[LastName] [varchar](240) NULL,
	[Company] [varchar](100) NULL,
	) 
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
