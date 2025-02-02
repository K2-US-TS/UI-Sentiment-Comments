/****** Object:  Table [dbo].[Comments]    Script Date: 10/27/2020 11:37:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RecordID] [int] NULL,
	[Application] [nvarchar](50) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedByDisplayName] [nvarchar](50) NULL,
	[Date] [datetime] NULL,
	[Title] [nvarchar](50) NULL,
	[CommentCategory] [nvarchar](50) NULL,
	[Reference] [nvarchar](50) NULL,
	[Comment] [nvarchar](max) NULL,
	[Sentiment] [decimal](18, 2) NULL,
	[Views] [int] NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[CommentListCSS]    Script Date: 10/27/2020 11:37:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CommentListCSS] @application nvarchar(max), @html nvarchar(max)=NULL OUTPUT
AS




DECLARE @htmltemp table (Temp NVARCHAR(max) )

INSERT INTO @htmltemp
SELECT '<style>


.containermessages {
  border: 2px solid #dedede;
  background-color: #f1f1f1;
  border-radius: 5px;
  padding: 10px;
  margin: 10px 0;
}

.containermessages darker {
  border-color: #ccc;
  background-color: #ddd;
}

.containermessages::after {
  content: "";
  clear: both;
  display: table;
}

.containermessages img {
  float: left;
  max-width: 60px;
  width: 100%;
  margin-right: 20px;
  border-radius: 50%;
}

.containermessages img.right {
  float: right;
  margin-left: 20px;
  margin-right:0;
}

.time-right {
  float: right;
  color: #aaa;
}

.time-left {
  float: left;
  color: #999;
}
</style>' 


 as Temp

SET @html = (SELECT * FROM @htmltemp)
SELECT @html





GO
/****** Object:  StoredProcedure [dbo].[CommentListHTML]    Script Date: 10/27/2020 11:37:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CommentListHTML] @ID int, @result nvarchar(max)=NULL OUTPUT, @fqn nvarchar(50), @application nvarchar(max)
AS



DECLARE @htmltemp2 TABLE (ID int, Temp NVARCHAR(max) )
INSERT INTO @htmltemp2

SELECT ID,'<div class="' + CASE WHEN [CreatedBy] = @fqn then 'containermessages' ELSE 'containermessages darker' END +'"><img src="' +  CASE WHEN [Sentiment] <= 1 and [Sentiment] >= 0.75 then 'https://tsdemos.blob.core.windows.net/iap/Icons/smile.png' WHEN [Sentiment] <= 0.74 and [Sentiment] >= 0.50 then 'https://tsdemos.blob.core.windows.net/iap/Icons/emoji.png' WHEN [Sentiment] <= 0.49 and [Sentiment] >= 0.20 then 'https://tsdemos.blob.core.windows.net/iap/Icons/sad.png' ELSE 'https://tsdemos.blob.core.windows.net/iap/Icons/angry.png' END + '" alt="Chat" 
class="' + CASE WHEN [CreatedBy] = @FQN then 'right' ELSE 'left' END + '" style="width:100%;"><p>' + Comment +'</p><span class ="' +  CASE WHEN CreatedBy = @fqn then 'time-right' ELSE 'time-left' END +'"><b>' + CommentCategory + '<br>' + CreatedByDisplayName + '</b><br>' +  CONVERT(VARCHAR, [Date])
 +'</span></div>' as temp
  FROM [dbo].[Comments]
 WHERE RecordID = @ID AND @application = [application]
ORDER BY [Date] DESC


  SELECT STRING_AGG(temp, ' ') WITHIN GROUP (ORDER BY ID DESC) as HTML
FROM @htmltemp2

DECLARE @HTML nvarchar(max)
SET @HTML = (SELECT STRING_AGG(temp, ' ') as HTML
FROM @htmltemp2)

Set @result = @HTML






GO
