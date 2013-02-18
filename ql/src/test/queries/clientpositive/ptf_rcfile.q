DROP TABLE part_rc;

CREATE TABLE part_rc( 
    p_partkey INT,
    p_name STRING,
    p_mfgr STRING,
    p_brand STRING,
    p_type STRING,
    p_size INT,
    p_container STRING,
    p_retailprice DOUBLE,
    p_comment STRING
)  STORED AS RCFILE ;

LOAD DATA LOCAL INPATH '../data/files/part.rc' overwrite into table part_rc;

-- testWindowingPTFWithPartRC
select p_mfgr, p_name, p_size, 
rank() as r, 
dense_rank() as dr, 
sum(p_retailprice) as s1 over (rows between unbounded preceding and current row) 
from noop(part_rc 
distribute by p_mfgr 
sort by p_name);