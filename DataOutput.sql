/********************************************************************************************
NAME: DataOutput
PURPOSE: Output data to create reports

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   11/04/2019  ESOARES   1. Built this script to output data and create reports.

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

USE [DFNB2];
SELECT *
FROM [dbo].[v_all_transactions];

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_fees_per_account]
ORDER BY 3 DESC, 
         4 DESC, 
         1;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_fees_per_branch]
ORDER BY 3 DESC, 
         4 DESC, 
         1;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_transaction_type];

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_transactions_at_other_branches]
ORDER BY 1, 
         2;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_transactions_volume]
ORDER BY 3, 
         2, 
         1;