#!/bin/bash

../../bin/csv2hive.sh --table-external --load-from-hdfs "/tmp/testdir" --parquet-db-name "myParquetDb" --parquet-table-name "myAirportTable" ../data/airports.csv

