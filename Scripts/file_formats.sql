-- Snowflake supports 6 different type of file formats
-- csv (delimited file formats)
-- JSON
-- Parquet
-- Avro
-- ORC
-- XML


-- simple csv file format

create or replace file format csv_simple_ff
  type = 'csv'
  compression = 'none'
  field_delimiter = ','
  record_delimiter = '\n'
  skip_header = 1;


-- with double quote

create or replace file format csv_double_q_ff
    type = 'csv'
    compression = 'none'
    field_delimiter = ','
    record_delimiter = '\n'
    skip_header = 1
    field_optionally_enclosed_by = '\042'
    trim_space = false
    error_on_column_count_mismatch = true;



-- with single quote

create or replace file format csv_single_q_ff
    type = 'csv'
    compression = 'none'
    field_delimiter = ','
    record_delimiter = '\n'
    skip_header = 1
    field_optionally_enclosed_by = '\047'
    trim_space = false
    error_on_column_count_mismatch = true;



-- other files

create or replace file format json_ff
type = 'JSON';

create or replace file format parquet_ff
type = 'Parquet';

create or replace file format avro_ff
type = 'AVRO';

create or replace file format orc_ff
type = 'ORC';



-- show file formats

show file formats;


-- desc file formats

desc file format csv_single_q_ff;



    
