#!/usr/bin/sh
#
#  Run this script on the server to transform the game-generated sql
#  files to something executable on the terminal;
#  Execute those sql files to create database tables;
#  Create Run Value tables;
#  Create CalcBatting and CalcPitching Tables
#

source .env


#  Replace all the leading '#' in the sql file with '--'
#  LOGGING
echo "[ " $DATE " ]" >> ootp.log
cd /home/rickybranch/mysql
for file in *
do
  sed -i "s/#/--/" $file
  echo $DATE " - processed " $file >> /home/rickybranch/ootp.log
done
#
#  Execute the game-generated sql scripts
cd /home/rickybranch/mysql
for file in *
do
  mysql -u rickybranch -pPASSWORD -D rb1 < $file
  echo $DATE " - executed " $file >> /home/rickybranch/ootp.log
done
#
#  Execute the script to add some indexes and create the first supplemental tables
echo "starting indexing script..."
mysql -u rickybranch -pPASSWORD -D rb1 < /home/rickybranch/sql_scripts/add_indexes.sql
echo "complete!"
echo $DATE " - indexing script executed" >> /home/rickybranch/ootp.log
#  Execute the script to create the run value tables
echo "starting run_values script..."
mysql -u rickybranch -pPASSWORD -D rb1 < /home/rickybranch/sql_scripts/run_values.sql
echo "complete!"
echo $DATE " - run values script executed" >> /home/rickybranch/ootp.log
# Execute calcbatting and calcpitching
echo "starting calcbatting..."
mysql -u rickybranch -pPASSWORD -D rb1 < /home/rickybranch/sql_scripts/calcbatting.sql
echo "complete!"
echo $DATE " - calcbatting script executed" >> /home/rickybranch/ootp.log
echo "starting calcpitching..."
mysql -u rickybranch -pPASSWORD -D rb1 < /home/rickybranch/sql_scripts/calcpitching.sql
echo "complete!"
echo $DATE " - calcpitching script executed"