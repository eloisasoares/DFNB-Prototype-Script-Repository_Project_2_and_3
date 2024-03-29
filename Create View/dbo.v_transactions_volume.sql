/********************************************************************************************
NAME: [dbo].[v_transactions_volume]
PURPOSE: Create the view [dbo].[v_transactions_volume]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   11/04/2019  ESOARES   1. Built this script to create the view [dbo].[v_transactions_volume].

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

DROP VIEW IF EXISTS [dbo].[v_transactions_volume];
GO
CREATE VIEW v_transactions_volume
AS
(
    SELECT bd.[branch_code], 
           ttd.[transaction_type_desc], 
           COUNT(tf.[transaction_date]) AS number_of_transactions
    FROM [dbo].[t_transaction_fact] AS tf
         LEFT JOIN [dbo].[t_branch_dim] AS bd ON tf.branch_id = bd.branch_id
         JOIN [dbo].[t_transaction_type_dim] AS ttd ON tf.transaction_type_id = ttd.transaction_type_id
	WHERE DATEPART(year, tf.[transaction_date]) = 2019
    GROUP BY bd.[branch_code], 
             ttd.[transaction_type_desc], 
             DATEPART(year, tf.[transaction_date])
);