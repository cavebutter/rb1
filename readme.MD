# OOTP-Web Backend and Infrastructure
This repository contains files and scripts for the backend operations of the OOTP website.
`oopt_client.py` is run on the machine that hosts the OOTP game.  It takes the sql exports and images and ftp's them to the server.
`server_script1.sh` is run on the server.  It does the following:
* Transforms the game-generated sql scripts to make them usable
* Executes the game-generated sql scripts to load them into MySQL db
* Executes the sql scripts included in this repository to add indexes, create run-value tables and the CalcBatting and CalcPitching tables.
