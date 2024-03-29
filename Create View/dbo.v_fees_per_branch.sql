/********************************************************************************************
NAME: [dbo].[v_fees_per_branch]
PURPOSE: Create the view [dbo].[v_fees_per_branch]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   11/04/2019  ESOARES   1. Built this script to create the view [dbo].[v_fees_per_branch].

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

DROP VIEW IF EXISTS [dbo].[v_fees_per_branch];
GO
CREATE VIEW v_fees_per_branch
AS
(
    SELECT bd.branch_description, 
           CONVERT(DECIMAL(15, 3), SUM(tf.[transaction_amt])) AS total_of_transactions, 
           SUM(tf.[transaction_fee_amt]) AS total_of_fees, 
           CONVERT(DECIMAL(3, 2), (SUM(tf.[transaction_fee_amt]) / SUM(tf.[transaction_amt]) * 100)) AS percentual
    FROM [dbo].[t_transaction_fact] AS tf
	JOIN [dbo].[t_branch_dim] AS bd ON tf.branch_id = bd.branch_id
    GROUP BY bd.branch_description
);