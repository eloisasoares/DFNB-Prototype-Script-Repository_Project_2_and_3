USE [master]
GO
/****** Object:  Database [DFNB2]    Script Date: 11/4/2019 10:31:44 PM ******/
CREATE DATABASE [DFNB2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DFNB2', FILENAME = N'E:\SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\DFNB2.mdf' , SIZE = 1498112KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DFNB2_log', FILENAME = N'E:\SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\DFNB2_log.ldf' , SIZE = 3729984KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DFNB2] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DFNB2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DFNB2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DFNB2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DFNB2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DFNB2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DFNB2] SET ARITHABORT OFF 
GO
ALTER DATABASE [DFNB2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DFNB2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DFNB2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DFNB2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DFNB2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DFNB2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DFNB2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DFNB2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DFNB2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DFNB2] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DFNB2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DFNB2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DFNB2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DFNB2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DFNB2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DFNB2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DFNB2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DFNB2] SET RECOVERY FULL 
GO
ALTER DATABASE [DFNB2] SET  MULTI_USER 
GO
ALTER DATABASE [DFNB2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DFNB2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DFNB2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DFNB2] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [DFNB2] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'DFNB2', N'ON'
GO
ALTER DATABASE [DFNB2] SET QUERY_STORE = OFF
GO
USE [DFNB2]
GO
/****** Object:  Table [dbo].[t_transaction_type_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_transaction_type_dim](
	[transaction_type_id] [int] NOT NULL,
	[transaction_type_code] [varchar](3) NOT NULL,
	[transaction_type_desc] [varchar](100) NOT NULL,
	[transaction_fee_prct] [decimal](4, 3) NOT NULL,
	[cur_cust_req_ind] [varchar](1) NOT NULL,
 CONSTRAINT [PK_t_transaction_type_dim] PRIMARY KEY CLUSTERED 
(
	[transaction_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_transaction_fact]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_transaction_fact](
	[transaction_date] [date] NOT NULL,
	[transaction_time] [time](7) NOT NULL,
	[branch_id] [int] NOT NULL,
	[acct_id] [int] NOT NULL,
	[transaction_type_id] [int] NOT NULL,
	[transaction_amt] [int] NOT NULL,
	[transaction_fee_amt] [decimal](15, 3) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_branch_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_branch_dim](
	[branch_id] [int] NOT NULL,
	[branch_code] [varchar](5) NOT NULL,
	[branch_description] [varchar](100) NOT NULL,
	[address_id] [int] NOT NULL,
	[region_id] [int] NOT NULL,
	[area_id] [int] NOT NULL,
 CONSTRAINT [PK_t_branch_dim] PRIMARY KEY CLUSTERED 
(
	[branch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_transactions_volume]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_transactions_volume]
AS
(
    SELECT bd.[branch_code], 
           ttd.[transaction_type_desc], 
           DATEPART(year, tf.[transaction_date]) AS date, 
           COUNT(tf.[transaction_date]) AS number_of_transactions
    FROM [dbo].[t_transaction_fact] AS tf
         LEFT JOIN [dbo].[t_branch_dim] AS bd ON tf.branch_id = bd.branch_id
         JOIN [dbo].[t_transaction_type_dim] AS ttd ON tf.transaction_type_id = ttd.transaction_type_id
    GROUP BY bd.[branch_code], 
             ttd.[transaction_type_desc], 
             DATEPART(year, tf.[transaction_date])
);
GO
/****** Object:  View [dbo].[v_fees_per_branch]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_fees_per_branch]
AS
(
    SELECT [branch_id], 
           CONVERT(DECIMAL(15, 3), SUM([transaction_amt])) AS total_of_transactions, 
           SUM([transaction_fee_amt]) AS total_of_fees, 
           CONVERT(DECIMAL(3, 2), (SUM([transaction_fee_amt]) / SUM([transaction_amt]) * 100)) AS percentual
    FROM [dbo].[t_transaction_fact]
    GROUP BY [branch_id]
);
GO
/****** Object:  View [dbo].[v_fees_per_account]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_fees_per_account]
AS
(
    SELECT [acct_id], 
           CONVERT(DECIMAL(15, 3), SUM([transaction_amt])) AS total_of_transactions, 
           SUM([transaction_fee_amt]) AS total_of_fees, 
           CONVERT(DECIMAL(3, 2), (SUM([transaction_fee_amt]) / SUM([transaction_amt]) * 100)) AS percentual
    FROM [dbo].[t_transaction_fact]
    GROUP BY [acct_id]
);
GO
/****** Object:  Table [dbo].[t_customer_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_customer_dim](
	[cust_id] [int] NOT NULL,
	[cust_last_name] [varchar](100) NOT NULL,
	[cust_first_name] [varchar](100) NOT NULL,
	[cust_gender] [varchar](1) NOT NULL,
	[cust_birth_date] [date] NOT NULL,
	[cust_since_date] [date] NOT NULL,
	[cust_pri_branch_dist] [decimal](7, 2) NOT NULL,
	[relationship_id] [int] NOT NULL,
	[address_id] [int] NOT NULL,
	[primary_branch_id] [int] NOT NULL,
 CONSTRAINT [PK_t_customer_dim] PRIMARY KEY CLUSTERED 
(
	[cust_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_customer_account_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_customer_account_dim](
	[customer_account_id] [int] IDENTITY(1,1) NOT NULL,
	[cust_id] [int] NOT NULL,
	[acct_id] [int] NOT NULL,
	[cust_role_id] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_transactions_at_other_branches]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_transactions_at_other_branches]
AS
(
    SELECT cd.[cust_id], 
           (cd.[cust_first_name] + ' ' + [cust_last_name]) AS customer_name,
           cd.[primary_branch_id] AS primary_branch,
           tf.[branch_id] AS trans_branch,
		   COUNT(tf.[transaction_date]) AS #_of_transactions
    FROM [dbo].[t_customer_dim] AS cd
         JOIN [dbo].[t_customer_account_dim] AS cad ON cd.cust_id = cad.cust_id
         JOIN [dbo].[t_transaction_fact] AS tf ON tf.acct_id = cad.acct_id
    WHERE cd.[cust_id] <> '-1'
    GROUP BY cd.[cust_id], 
             (cd.[cust_first_name] + ' ' + [cust_last_name]),
             cd.[primary_branch_id],
             tf.[branch_id]
);
GO
/****** Object:  View [dbo].[v_transaction_type]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_transaction_type]
AS
(
    SELECT ttd.[transaction_type_desc], 
           COUNT(tf.[transaction_date]) AS number_of_transactions, 
           SUM(convert(decimal(15,0),tf.[transaction_amt])) AS transactions_amt
    FROM [dbo].[t_transaction_fact] AS tf
         JOIN [dbo].[t_transaction_type_dim] AS ttd ON tf.transaction_type_id = ttd.transaction_type_id
    GROUP BY ttd.[transaction_type_desc]
);
GO
/****** Object:  View [dbo].[v_all_transactions]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_all_transactions]
AS
(
    SELECT tf.[transaction_date], 
           tf.[transaction_time], 
           tf.[branch_id], 
           tf.[acct_id], 
           tf.[transaction_type_id], 
           ttd.[transaction_type_code], 
           ttd.[transaction_type_desc], 
           ttd.[transaction_fee_prct], 
           ttd.[cur_cust_req_ind], 
           tf.[transaction_amt], 
           tf.[transaction_fee_amt]
    FROM [dbo].[t_transaction_fact] AS tf
         JOIN [dbo].[t_transaction_type_dim] AS ttd ON tf.transaction_type_id = ttd.transaction_type_id
);
GO
/****** Object:  Table [dbo].[t_account_fact]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_account_fact](
	[as_of_date] [date] NOT NULL,
	[acct_id] [int] NOT NULL,
	[cur_balance] [decimal](20, 4) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_account_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_account_dim](
	[acct_id] [int] NOT NULL,
	[acct_open_date] [date] NOT NULL,
	[acct_close_date] [date] NOT NULL,
	[acct_open_close_code] [varchar](1) NOT NULL,
	[loan_amt] [decimal](20, 4) NOT NULL,
	[primary_cust_id] [int] NOT NULL,
	[branch_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
 CONSTRAINT [PK_t_account_dim] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_new_loans]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_new_loans]
AS
     SELECT DATEPART(YEAR, ad.[acct_open_date]) AS Year, 
            af.[acct_id], 
            MAX(ad.[loan_amt]) AS Total_Loans, 
            bd.[branch_code], 
            bd.[region_id] AS Region, 
            bd.[area_id] AS Area
     FROM [dbo].[t_account_dim] AS ad
          JOIN [dbo].[t_account_fact] AS af ON ad.[acct_id] = af.[acct_id]
          JOIN [dbo].[t_branch_dim] AS bd ON bd.[branch_id] = ad.[branch_id]
     GROUP BY DATEPART(YEAR, ad.[acct_open_date]), 
              af.[acct_id], 
              bd.[branch_code], 
              bd.[region_id], 
              bd.[area_id];
GO
/****** Object:  View [dbo].[v_new_customers]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_new_customers]
AS
     SELECT DATEPART(YEAR, cd.[cust_since_date]) AS Year, 
            bd.[branch_code] AS Branch, 
            bd.[region_id] AS Region, 
            bd.[area_id] AS Area, 
            COUNT(cd.[cust_id]) AS Total_New_Customers
     FROM [dbo].[t_customer_dim] AS cd
          JOIN [dbo].[t_branch_dim] AS bd ON cd.[primary_branch_id] = bd.[branch_id]
     GROUP BY DATEPART(YEAR, cd.[cust_since_date]), 
              bd.[branch_code], 
              bd.[region_id], 
              bd.[area_id];
GO
/****** Object:  View [dbo].[v_balance]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_balance]
AS
     SELECT af.acct_id, 
            ad.acct_open_date AS loan_date, 
            CONVERT(DECIMAL(10, 0), ad.loan_amt) AS loan_amt, 
            af.as_of_date AS balance_date, 
            ROW_NUMBER() OVER(PARTITION BY af.acct_id, 
                                           ad.loan_amt
            ORDER BY af.acct_id, 
                     af.as_of_date, 
                     af.cur_balance DESC) AS period, 
            CONVERT(DECIMAL(10, 0), (CASE
                                         WHEN LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                                     ORDER BY af.acct_id, 
                                              af.as_of_date, 
                                              af.cur_balance DESC) IS NULL
                                         THEN ad.loan_amt
                                         ELSE LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                                         ORDER BY af.acct_id, 
                                                  af.as_of_date, 
                                                  af.cur_balance DESC)
                                     END)) AS previous_balance, 
            CONVERT(DECIMAL(10, 0), af.cur_balance - CASE
                                                         WHEN LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                                                     ORDER BY af.acct_id, 
                                                              af.as_of_date, 
                                                              af.cur_balance DESC) IS NULL
                                                         THEN ad.loan_amt
                                                         ELSE LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                                                         ORDER BY af.acct_id, 
                                                                  af.as_of_date, 
                                                                  af.cur_balance DESC)
                                                     END) AS payment, 
            CONVERT(DECIMAL(10, 0), af.cur_balance) AS current_balance,
            CASE
                WHEN CASE
                         WHEN LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                     ORDER BY af.acct_id, 
                              af.as_of_date, 
                              af.cur_balance DESC) IS NULL
                         THEN ad.loan_amt
                         ELSE LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                         ORDER BY af.acct_id, 
                                  af.as_of_date, 
                                  af.cur_balance DESC)
                     END < af.[cur_balance]
                THEN 'MORE CHARGES ADDED'
                WHEN CASE
                         WHEN LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                     ORDER BY af.acct_id, 
                              af.as_of_date, 
                              af.cur_balance DESC) IS NULL
                         THEN ad.loan_amt
                         ELSE LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                         ORDER BY af.acct_id, 
                                  af.as_of_date, 
                                  af.cur_balance DESC)
                     END > af.[cur_balance]
                THEN 'PAYMENT DONE'
                ELSE 'NO PAYMENT IN THE PERIOD'
            END AS Payment_Status
     FROM dbo.t_account_fact AS af
          JOIN dbo.t_account_dim AS ad ON ad.acct_id = af.acct_id;
GO
/****** Object:  View [dbo].[v_new_accounts]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_new_accounts]
AS
     SELECT DATEPART(YEAR, ad.[acct_open_date]) AS Year, 
            bd.[branch_code] AS Branch, 
            bd.[region_id] AS Region, 
            bd.[area_id] AS Area, 
            COUNT(ad.[acct_id]) AS Total_New_Accounts
     FROM [dbo].[t_account_dim] AS ad
          JOIN [dbo].[t_branch_dim] AS bd ON bd.[branch_id] = ad.[branch_id]
          JOIN [dbo].[t_customer_dim] AS cd ON cd.[cust_id] = ad.[primary_cust_id]
     GROUP BY DATEPART(YEAR, ad.[acct_open_date]), 
              bd.[branch_code], 
              bd.[region_id], 
              bd.[area_id];
GO
/****** Object:  View [dbo].[v_customers_per_client]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_customers_per_client]
AS
select DATEPART(YEAR, cd.[cust_since_date]) AS year
		,cad.[acct_id]
		,COUNT(cd.[cust_id]) as customers
		,cd.[relationship_id]
		,CONVERT(DECIMAL(10, 0),SUM(ad.loan_amt)) as loans
from [dbo].[t_customer_dim] as cd
join [dbo].[t_customer_account_dim] as cad on cd.[cust_id] = cad.cust_id
join [dbo].[t_account_dim] as ad on ad.acct_id = cad.acct_id
group by DATEPART(YEAR, cd.[cust_since_date])
,cad.[acct_id]
,cad.cust_role_id
,cd.[relationship_id];
GO
/****** Object:  View [dbo].[v_accounts_per_customer_per_year]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_accounts_per_customer_per_year]
AS
select DATEPART(YEAR, cd.[cust_since_date]) AS year
		,cd.[cust_id]
		,(cd.cust_first_name + ' ' +cd.cust_last_name) as customer_name
		,cad.cust_role_id
		,COUNT(cad.[acct_id]) as accounts
		,cd.[relationship_id]
		,CONVERT(DECIMAL(10, 0),SUM(ad.loan_amt)) as loans
from [dbo].[t_customer_dim] as cd
join [dbo].[t_customer_account_dim] as cad on cd.[cust_id] = cad.cust_id
join [dbo].[t_account_dim] as ad on ad.acct_id = cad.acct_id
group by DATEPART(YEAR, cd.[cust_since_date])
,cd.[cust_id]
,(cd.cust_first_name + ' ' +cd.cust_last_name)
,cad.cust_role_id
,cd.[relationship_id];
GO
/****** Object:  Table [dbo].[stg_p1]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_p1](
	[acct_id] [int] NOT NULL,
	[cust_id] [smallint] NOT NULL,
	[acct_cust_role_id] [smallint] NOT NULL,
	[acct_id2] [int] NOT NULL,
	[prod_id] [smallint] NOT NULL,
	[open_date] [date] NOT NULL,
	[close_date] [date] NOT NULL,
	[open_close_code] [varchar](1) NOT NULL,
	[branch_id] [smallint] NOT NULL,
	[acct_rel_id] [smallint] NOT NULL,
	[pri_cust_id] [smallint] NOT NULL,
	[loan_amt] [decimal](20, 4) NOT NULL,
	[acct_branch_id] [smallint] NOT NULL,
	[acct_branch_code] [varchar](5) NOT NULL,
	[acct_branch_desc] [varchar](100) NOT NULL,
	[acct_region_id] [int] NOT NULL,
	[acct_area_id] [int] NOT NULL,
	[acct_branch_lat] [decimal](16, 12) NOT NULL,
	[acct_branch_lon] [decimal](16, 12) NOT NULL,
	[acct_branch_add_id] [int] NOT NULL,
	[acct_branch_add_lat] [decimal](16, 12) NOT NULL,
	[acct_branch_add_lon] [decimal](16, 12) NOT NULL,
	[acct_branch_add_type] [varchar](1) NOT NULL,
	[cust_id2] [smallint] NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[first_name] [varchar](100) NOT NULL,
	[gender] [varchar](1) NOT NULL,
	[birth_date] [date] NOT NULL,
	[cust_since_date] [date] NOT NULL,
	[pri_branch_id] [smallint] NOT NULL,
	[cust_pri_branch_dist] [decimal](7, 2) NOT NULL,
	[cust_lat] [decimal](16, 12) NOT NULL,
	[cust_lon] [decimal](16, 12) NOT NULL,
	[cust_rel_id] [smallint] NOT NULL,
	[cust_add_id] [int] NOT NULL,
	[cust_add_lat] [decimal](16, 12) NOT NULL,
	[cust_add_lon] [decimal](16, 12) NOT NULL,
	[cust_add_type] [varchar](1) NOT NULL,
	[as_of_date] [date] NOT NULL,
	[acct_id3] [int] NOT NULL,
	[cur_bal] [decimal](20, 4) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_p2]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_p2](
	[branch_id] [smallint] NOT NULL,
	[acct_id] [int] NOT NULL,
	[tran_date] [date] NOT NULL,
	[tran_time] [time](7) NOT NULL,
	[tran_type_id] [smallint] NOT NULL,
	[tran_type_code] [varchar](5) NOT NULL,
	[tran_type_desc] [varchar](100) NOT NULL,
	[tran_fee_prct] [decimal](4, 3) NOT NULL,
	[cur_cust_req_ind] [varchar](1) NOT NULL,
	[tran_amt] [int] NOT NULL,
	[tran_fee_amt] [decimal](15, 3) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_address_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_address_dim](
	[address_id] [int] NOT NULL,
	[address_type] [varchar](1) NOT NULL,
	[latitude] [decimal](16, 12) NOT NULL,
	[longitude] [decimal](16, 12) NOT NULL,
 CONSTRAINT [PK_t_address_dim] PRIMARY KEY CLUSTERED 
(
	[address_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_area_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_area_dim](
	[area_id] [int] NOT NULL,
	[area_name] [varchar](50) NULL,
 CONSTRAINT [PK_t_area_dim] PRIMARY KEY CLUSTERED 
(
	[area_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_customer_role_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_customer_role_dim](
	[cust_role_id] [int] NOT NULL,
	[cust_role_description] [varchar](100) NULL,
 CONSTRAINT [PK_t_customer_role_dim] PRIMARY KEY CLUSTERED 
(
	[cust_role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_product_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_product_dim](
	[product_id] [int] NOT NULL,
	[product_description] [varchar](100) NULL,
 CONSTRAINT [PK_t_product_dim] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_region_dim]    Script Date: 11/4/2019 10:31:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_region_dim](
	[region_id] [int] NOT NULL,
	[region_name] [varchar](50) NULL,
 CONSTRAINT [PK_t_region_dim] PRIMARY KEY CLUSTERED 
(
	[region_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_account_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_account_dim_t_branch_dim] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])
GO
ALTER TABLE [dbo].[t_account_dim] CHECK CONSTRAINT [FK_t_account_dim_t_branch_dim]
GO
ALTER TABLE [dbo].[t_account_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_account_dim_t_customer_dim] FOREIGN KEY([primary_cust_id])
REFERENCES [dbo].[t_customer_dim] ([cust_id])
GO
ALTER TABLE [dbo].[t_account_dim] CHECK CONSTRAINT [FK_t_account_dim_t_customer_dim]
GO
ALTER TABLE [dbo].[t_account_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_account_dim_t_product_dim] FOREIGN KEY([product_id])
REFERENCES [dbo].[t_product_dim] ([product_id])
GO
ALTER TABLE [dbo].[t_account_dim] CHECK CONSTRAINT [FK_t_account_dim_t_product_dim]
GO
ALTER TABLE [dbo].[t_account_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_account_fact_t_account_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_account_dim] ([acct_id])
GO
ALTER TABLE [dbo].[t_account_fact] CHECK CONSTRAINT [FK_t_account_fact_t_account_dim]
GO
ALTER TABLE [dbo].[t_branch_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_address_dim] FOREIGN KEY([address_id])
REFERENCES [dbo].[t_address_dim] ([address_id])
GO
ALTER TABLE [dbo].[t_branch_dim] CHECK CONSTRAINT [FK_t_branch_dim_t_address_dim]
GO
ALTER TABLE [dbo].[t_branch_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_area_dim] FOREIGN KEY([area_id])
REFERENCES [dbo].[t_area_dim] ([area_id])
GO
ALTER TABLE [dbo].[t_branch_dim] CHECK CONSTRAINT [FK_t_branch_dim_t_area_dim]
GO
ALTER TABLE [dbo].[t_branch_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_region_dim] FOREIGN KEY([region_id])
REFERENCES [dbo].[t_region_dim] ([region_id])
GO
ALTER TABLE [dbo].[t_branch_dim] CHECK CONSTRAINT [FK_t_branch_dim_t_region_dim]
GO
ALTER TABLE [dbo].[t_customer_account_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_customer_account_dim_t_account_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_account_dim] ([acct_id])
GO
ALTER TABLE [dbo].[t_customer_account_dim] CHECK CONSTRAINT [FK_t_customer_account_dim_t_account_dim]
GO
ALTER TABLE [dbo].[t_customer_account_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_customer_account_dim_t_customer_dim] FOREIGN KEY([cust_id])
REFERENCES [dbo].[t_customer_dim] ([cust_id])
GO
ALTER TABLE [dbo].[t_customer_account_dim] CHECK CONSTRAINT [FK_t_customer_account_dim_t_customer_dim]
GO
ALTER TABLE [dbo].[t_customer_account_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_customer_account_dim_t_customer_role_dim] FOREIGN KEY([cust_role_id])
REFERENCES [dbo].[t_customer_role_dim] ([cust_role_id])
GO
ALTER TABLE [dbo].[t_customer_account_dim] CHECK CONSTRAINT [FK_t_customer_account_dim_t_customer_role_dim]
GO
ALTER TABLE [dbo].[t_customer_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_customer_dim_t_address_dim] FOREIGN KEY([address_id])
REFERENCES [dbo].[t_address_dim] ([address_id])
GO
ALTER TABLE [dbo].[t_customer_dim] CHECK CONSTRAINT [FK_t_customer_dim_t_address_dim]
GO
ALTER TABLE [dbo].[t_customer_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_customer_dim_t_branch_dim] FOREIGN KEY([primary_branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])
GO
ALTER TABLE [dbo].[t_customer_dim] CHECK CONSTRAINT [FK_t_customer_dim_t_branch_dim]
GO
ALTER TABLE [dbo].[t_transaction_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_transaction_fact_t_account_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_account_dim] ([acct_id])
GO
ALTER TABLE [dbo].[t_transaction_fact] CHECK CONSTRAINT [FK_t_transaction_fact_t_account_dim]
GO
ALTER TABLE [dbo].[t_transaction_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_transaction_fact_t_branch_dim] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])
GO
ALTER TABLE [dbo].[t_transaction_fact] CHECK CONSTRAINT [FK_t_transaction_fact_t_branch_dim]
GO
ALTER TABLE [dbo].[t_transaction_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_transaction_fact_t_transaction_type_dim] FOREIGN KEY([transaction_type_id])
REFERENCES [dbo].[t_transaction_type_dim] ([transaction_type_id])
GO
ALTER TABLE [dbo].[t_transaction_fact] CHECK CONSTRAINT [FK_t_transaction_fact_t_transaction_type_dim]
GO
USE [master]
GO
ALTER DATABASE [DFNB2] SET  READ_WRITE 
GO
