#!/bin/bash

../../bin/csv2hive.sh -csv2hive.sh --create\
 --parquet-db-name "myParquetDb"\
 --parquet-table-name "myAirportTable"\
 --parquet-row-format "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"\
 --parquet-input-format "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"\
 --parquet-output-format "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"\
 --parquet-compression "none"\
 ../data/airports.csv

