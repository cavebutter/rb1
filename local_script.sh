#!/usr/bin/env sh
#
# This is script similar to server_script1.sh but for the local development machine.
# It will pull game generated sql scripts from their original location
# copy them to a staging area, and perform the rest of the ELT tasks to the
# localhost db.
# Copy Files
cd "/Users/Jayco/Application Support/Out of the Park Developments/OOTP Baseball 22/saved_games/federated1.lg/import_export/mysql"
cp *.sql /Users/Jayco/projects/rb1/local_sql_files
# Transform files
cd /Users/Jayco/projects/rb1/local_sql_files
for file in *
do
  sed -i "s/#/--/" $file
  echo "Processed " $file
done
# Execute game-generated sql scripts
for file in *
do
  mysql -u jayco -pd0ghouse -D rb1 < $file
  echo "Executed " $file
done
# Execute scripts to add indexes, run values, and calculated stats
echo "Starting Indexing Script"
mysql -u jayco -pd0ghouse -D rb1 < /Users/Jayco/projects/rb1/add_indexes.sql
echo Indexing Script Complete
echo "Starting Run Values Script"
mysql -u jayco -pd0ghouse -D rb1 < /Users/Jayco/projects/rb1/run_values.sql
echo "Run Values Complete"
echo "Starting CalcBatting"
mysql -u jayco -pd0ghouse -D rb1 < /Users/Jayco/projects/rb1/calcbatting.sql
echo "CalcBatting Complete"
echo "Starting CalcPitching"
mysql -u jayco -pd0ghouse -D rb1 < /Users/Jayco/projects/rb1/calcpitching.sql
echo "CalcPitching Complete"
