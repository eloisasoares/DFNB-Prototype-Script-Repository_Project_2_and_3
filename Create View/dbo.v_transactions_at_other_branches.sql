/********************************************************************************************
NAME: [dbo].[v_transactions_at_other_branches]
PURPOSE: Create the view [dbo].[v_transactions_at_other_branches]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   11/04/2019  ESOARES   1. Built this script to create the view [dbo].[v_transactions_at_other_branches].

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

DROP VIEW IF EXISTS [dbo].[v_transactions_at_other_branches];
GO

CREATE VIEW v_transactions_at_other_branches
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