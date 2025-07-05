/* 
-------------------------------------------------------
-- EXPLORING SNOWFLAKE USEFUL COMMANDS
---------------------------------------------------------

*/

-- Snowflake offers 4 types of stage objects
/* 

stage object -- is a storage location in snowflake where you can keep different kinds of 
files such as CSV, Excel, Parquet, JSON, XML etc.

-- external stage objects
-- internal stage objects
-- table stage objects
-- user stage objects

*/


-- creating an external stage object

create or replace stage my_ext_stg
url = 's3://snowflake-workshop-lab/weather-nyc'
comment = 'an external stage with aws/s3 object storage';

-- creating an internal stage

create or replace stage my_int_stg
comment = 'an internal stage';

-- describe the stage object

desc stage my_ext_stg;
desc stage my_int_stg;

--list all the stage objects within database and schema

show stages;

-- list all the files stored in a stage location

list @my_ext_stg;

list @my_int_stg;


-- user stage: every user in snowflake will automatically be assigned to a stage location
-- where all your worksheet or any other internal files are stored. 
-- To see what all things available in your User stage location

list @~;
DEMO_DB.PUBLIC
-- Likewise, we have a table stage, where first we need to create a table

create or replace transient table demo_db.public.customer (
    cust_key number,
    name text,
    address text,
    nation_name text,
    phone text,
    acct_bal number,
    mkt_segment text
);

-- then we can check the table stage (also called internal unnamed stages where you cannot change the name)
-- NOTE: the user and table stages are not visible in our home page.

list @%customer;










