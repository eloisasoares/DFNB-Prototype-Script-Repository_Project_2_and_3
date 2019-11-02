/********************************************************************************************
NAME: [dbo].[t_branch_dim]
PURPOSE: Create the table [dbo].[t_branch_dim]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   10/22/2019  ESOARES   1. Built this script to create the table [dbo].[t_branch_dim].
1.1	 10/23/2019  ESOARES   1. Changed the statement that adds the Primary Key to determine its name.

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

DROP TABLE IF EXISTS t_branch_dim;

CREATE TABLE t_branch_dim ( 
             branch_id          INT NOT NULL , 
             branch_code        VARCHAR(5) NOT NULL , 
             branch_description VARCHAR(100) NOT NULL , 
             address_id         INT NOT NULL , 
             region_id          INT NOT NULL , 
             area_id            INT NOT NULL CONSTRAINT PK_t_branch_dim PRIMARY KEY CLUSTERED(branch_id ASC)
                          );