#! /Users/Jayco/projects/rb1/venv/bin/python3

import os
from dotenv import load_dotenv
import ftplib
import mysql.connector
import logging
import time

logging.basicConfig(filename='image.log', filemode='w', format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logging.getLogger().setLevel(logging.DEBUG)
load_dotenv()

#  All the variables
db_host = os.getenv('db_host')
db_user = os.getenv("db_user")
db_password = os.getenv("db_password")
server_host = os.getenv("server_host")
server_user = os.getenv("server_user")
server_pass = os.getenv("server_pass")
src_mysql_dir = os.getenv("src_mysql_dir")
person_image_dir = os.getenv("person_image_dir")
league_image_dir = os.getenv("league_image_dir")
team_logo_dir = os.getenv("team_logo_dir")
db_name = os.getenv("db_name")
mysql_upload_dir = os.getenv("mysql_upload_dir")
player_image_upload_dir = os.getenv("player_image_upload_dir")
league_image_upload_dir = os.getenv("league_image_upload_dir")
team_images_upload_dir = os.getenv("team_images_upload_dir")
team_images_stage = os.getenv("team_logo_stage")
league_images_stage = os.getenv("league_image_stage")

def ftp_dir(ftp, src_dir, dest_dir):
    """
    FTP every file in src_dir to dest_dir using ftp login
    :param ftp: login
    :param src_dir:
    :param dest_dir:
    :return: count of items transferred
    """
    ftp.cwd(dest_dir)
    count = 0
    os.chdir(src_dir)
    tic = time.perf_counter()
    for item in os.listdir(os.getcwd()):
        package = open(item, 'rb')
        ftp.storbinary("STOR " + item, package)
        package.close()
        count += 1
    toc = time.perf_counter()
    elapsed_time = round(toc - tic,2)
    return (count, elapsed_time)

if __name__ == "__main__":
    try:
        cnx = mysql.connector.connect(user = db_user, password = db_password, host=db_host, database=db_name)
        logging.debug("Successful connection to database")
    except Exception as e:
        logging.error("Error connecting to databse", exc_info=True)

    teams_query = """SELECT 
    """