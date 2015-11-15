# Data for SQL Bootcamp

The scripts in this repo take a number of csvs (in the `data/` subdirectory), and rearrange them into well normalized tables, before dumping out the SQL code that will allow a MySQL database to read them back in.

This SQL data is used to teach a two-day SQL bootcamp.

Data sources:

   * State populations are taken from the 2013 census data
   * List of presidents comes from Wikipedia, merged with a list of presidential borth and death dates found on the internet
   * State water and land areas come from Wikipedia's list of state's geographic features
   * List of books written by presidents comes from Wikipedia's list of presidential autobiographies

## Running the script

The following two commands should be enough

    pip install -r requirements.txt
    python sql_bootcamp_data_construct.py
