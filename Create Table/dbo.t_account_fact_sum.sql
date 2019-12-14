/********************************************************************************************
NAME: [dbo].[t_account_fact_sum]
PURPOSE: Create the table [dbo].[t_account_fact_sum]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   12/13/2019  ESOARES   1. Built this script to create the table [dbo].[t_account_fact_sum].

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

DROP TABLE IF EXISTS t_account_fact_sum;

CREATE TABLE t_account_fact_sum ( 
             as_of_date  DATE NOT NULL , 
             acct_id     INT NOT NULL , 
             balance DECIMAL(20 , 4) NOT NULL);