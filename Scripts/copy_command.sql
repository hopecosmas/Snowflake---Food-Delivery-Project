-- We're gonna explore the use of COPY command in Snowflake




create or replace database demo_db;

----------------------------
-- Step 1: Create Tables
-----------------------------

-- create table for Departments

create or replace table demo_db.public.departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    create_date TIMESTAMP NOT NULL,
    modified_date TIMESTAMP NOT NULL
);


-- create a table for Employees

create or replace table demo_db.public.employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR (100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dob DATE NOT NULL,
    mobile_number VARCHAR(20) NOT NULL,
    designation VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    create_date TIMESTAMP NOT NULL,
    modified_date TIMESTAMP NOT NULL,
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
  
);


-------------------------------------------
-- Step 2: Create File Formats and Stage 
-------------------------------------------


-- create file format to process the CSV file

create file format if not exists demo_db.public.csv_ff
    type = 'csv'
    compression = 'auto'
    field_delimiter = ','
    record_delimiter = '\n'
    skip_header = 1
    field_optionally_enclosed_by = '\042'
    null_if = ('\\N');


-- create snowflake internal stage

create or replace stage demo_db.public.internal_csv_stg
    directory = (enable = true)
    comment = 'this is the snowflake internal stage';




-- Query department csv data using $ notation

select
  t.$1::INT as department_id,
  t.$2::TEXT as department_name,
  t.$3::TIMESTAMP as create_date,
  t.$4::TIMESTAMP as modified_date
from @demo_db.public.internal_csv_stg/department/departments.csv
(file_format => 'demo_db.public.csv_ff') t;


-- Query employee csv data using $ notation

select 
    t.$1::INT as emp_id,
    t.$2::TEXT as name,
    t.$3::TEXT as email,
    t.$4::DATE as dob,
    t.$5::TEXT as mobile_number,
    t.$6::TEXT as designation,
    t.$7::INT as department_id,
    t.$8::TIMESTAMP as create_date,
    t.$9::TIMESTAMP as modified_date
from @demo_db.public.internal_csv_stg/employee/employees.csv
(file_format => 'demo_db.public.csv_ff') t; 


--------------------------------------------------
--- Step 3: Use Copy to load the data into tables
--------------------------------------------------

copy into demo_db.public.departments
from @demo_db.public.internal_csv_stg/department/departments.csv
file_format = (format_name = 'demo_db.public.csv_ff');

-- another way to copy in case there are some transformations you want to apply before loading the data
-- into the specific table, you could do this:


copy into demo_db.public.departments
from (
     select
       t.$1:: INT as department_id,
       t.$2::TEXT as department_name,
       t.$3::TIMESTAMP as create_date,
       t.$4::TIMESTAMP as modified_date
     from @demo_db.public.internal_csv_stg/department/departments.csv t    
)
file_format = (format_name = 'demo_db.public.csv_ff')
force = true -- because we already loaded file above, use force=true to force 'reload'
on_error = abort_statement;




