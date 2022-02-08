#!/usr/bin/sh
#
#  Run this script on the server to transform the game-generated sql
#  files to something executable on the terminal;
#  Execute those sql files to create database tables;
#  Create Run Value tables;
#  Create CalcBatting and CalcPitching Tables
#
#  Replace all the leading '#' in the sql file with '--'
cd /home/rickybranch/mysql
for file in *
do
  sed -i "s/#/--/" $file
done
#
#  Execute the game-generated sql scripts
cd /home/rickybranch/mysql
for file in *
do
  mysql -u rickybranch -pPASSWORD -D rb1 < $file
done

#  Execute the script to add some indexes and create the first supplemental tables
mysql -u rickybranch -pPASSWORD -D rb1 < /home/rickybranch/sql_scripts/add_indexes.sql

#  Execute the script to create the run value tables
mysql -u rickybranch -pPASSWORD -D rb1 < /home/rickybranch/sql_scripts/run_values.sql

# Execute calcbatting and calcpitching
mysql -u rickybranch -pPASSWORD -D rb1 < /home/rickybranch/sql_scripts/calcbatting.sql
mysql -u rickybranch -pPASSWORD -D rb1 < /home/rickybranch/sql_scripts/calcpitching.sql
