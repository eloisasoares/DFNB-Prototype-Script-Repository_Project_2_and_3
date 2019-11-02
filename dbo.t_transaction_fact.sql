/********************************************************************************************
NAME: [dbo].[t_transaction_fact]
PURPOSE: Create the table [dbo].[t_transaction_fact]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   11/01/2019  ESOARES   1. Built this script to create the table [dbo].[t_transaction_fact].

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

DROP TABLE IF EXISTS t_transaction_fact;

CREATE TABLE t_transaction_fact ( 
             transaction_date    DATE NOT NULL , 
             transaction_time    TIME(7) NOT NULL , 
             branch_id           INT NOT NULL , 
             acct_id             INT NOT NULL , 
             transaction_type_id INT NOT NULL , 
             transaction_amt     INT NOT NULL , 
             transaction_fee_amt DECIMAL(15 , 3) NOT NULL
                                );