/********************************************************************************************
NAME: [dbo].[v_all]
PURPOSE: Create the view [dbo].[v_all]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   11/13/2019  ESOARES   1. Built this script to create the view [dbo].[v_all].

RUNTIME: 
1 min

NOTES: 
(...)

LICENSE: 
This code is covered by the GNU General Public License which guarantees end users
the freedom to run, study, share, and modify the code. This license grants the recipients
of the code the rights of the Free Software Definition. All derivative work can only be
distributed under the same license terms.

********************************************************************************************/

DROP VIEW IF EXISTS [dbo].[v_all];
GO
CREATE VIEW v_all
AS
(
SELECT tf.transaction_date, 
       tf.transaction_time, 
       bd.branch_code, 
       bd.branch_description, 
       bd.area_id, 
       bd.region_id, 
       tf.acct_id, 
       concat(
(
    SELECT cust_first_name
    FROM [dbo].[t_customer_dim]
    WHERE cust_id = ad.primary_cust_id
), ' ',
(
    SELECT cust_last_name
    FROM [dbo].[t_customer_dim]
    WHERE [cust_id] = ad.primary_cust_id
)) AS cust_name, 
       DATEPART(year,
(
    SELECT cust_birth_date
    FROM [dbo].[t_customer_dim]
    WHERE cust_id = ad.primary_cust_id
)) AS birth_year, 
(
    SELECT cust_gender
    FROM [dbo].[t_customer_dim]
    WHERE cust_id = ad.primary_cust_id
) cust_gender, 
       ttd.transaction_type_desc, 
       tf.transaction_amt, 
       tf.transaction_fee_amt, 
       ttd.transaction_fee_prct
FROM [dbo].[t_transaction_fact] AS tf
     LEFT JOIN [dbo].[t_transaction_type_dim] AS ttd ON tf.transaction_type_id = ttd.transaction_type_id
     LEFT JOIN [dbo].[t_branch_dim] AS bd ON tf.branch_id = bd.branch_id
     LEFT JOIN [dbo].[t_account_dim] AS ad ON tf.acct_id = ad.acct_id
	 );