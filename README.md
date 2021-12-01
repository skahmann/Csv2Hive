![](/Csv2Hive-logo.png "Csv2Hive")

## "The data together with its schema, is fully self-describing"

The philosophy of Csv2Hive is that the data, together with its schema, is fully self-describing. This approach is dynamic, so you don't need to write any schemas at all. To allow this dynamic behaviour, Csv2Hive parses automatically the first thousands lines for each CSV file it operates, in order to infer the right types for all columns. Further to facilitate the automation, Csv2Hive infers dynamically which kind of delimiter each CSV file is using.

## Requirements
* Requires a Unix or a Linux operating system to run
* Requires Python V2.7
  * Examples of commands to install Python on Linux (e.g: Debian, Ubuntu) :
    * $ sudo apt-get install python-dev python-pip python-setuptools build-essential
    * $ pip install setuptools --upgrade
* Requires CsvKit V0.9.0 (https://csvkit.readthedocs.org/)
  * Commands to install CsvKit :
    * $ pip install csvkit
    * $ pip install csvkit --upgrade
  * PIP requirements to install CsvKit-0.9.0 in offline mode (e.g: useful for safe install on a hadoop node) :
    * xlrd-0.9.3, SQLAlchemy-0.9.9, jdcal-1.0, openpyxl-2.2.0, six-1.9.0, python-dateutil-2.2, dbf-0.94.003

## Executing
Example with direct executing :
```
$ unzip Csv2Hive-master.zip -d ~ ; mv ~/Csv2Hive-master ~/Csv2Hive
$ ~/Csv2Hive/bin/csv2hive.sh myCsvFile.csv
```
Example with configuring your PATH :
```
$ export PATH=/home/`whoami`/Csv2Hive/bin:$PATH
$ csv2hive.sh myCsvFile.csv
```
Example with referencing into /usr/bin :
```
$ sudo mv ~/Csv2Hive /usr/lib
$ sudo ln -s /usr/lib/Csv2Hive/bin/csv2hive.sh /usr/bin/csv2hive
$ csv2hive myTsvFile.tsv
```

## Usage
```
usage: csv2hive [CSV_FILE] {WORK_DIR}

Generate a Hive 'CREATE TABLE' statement given a CSV file and execute that
statement directly on Hive by uploading the CSV file to HDFS.
The Parquet format is also supported.

positional argument:
  CSV_FILE      The CSV file to operate on.
  WORK_DIR      The work directory where to create the Hive file (optional).
                If missing, the work directory will be the same as the CSV file.
                In that directory, the name of the output Hive file will be the
                same as the CSV file but with the extension '.hql'.

optional arguments:
  --version     Show the version of this program.
  -h, --help    Show this help message and exit.
  -d DELIMITER, --delimiter DELIMITER
                Specify the delimiter used in the CSV file.
                If not present without -t nor --tab, then the delimiter will
                be discovered automatically between :
                {"," "\t" ";" "|" "\s"}.
  -t, --tab     Indicates that the tab delimiter is used in the CSV file.
                Overrides -d and --delimiter.
                If not present without -d nor --delimiter, then the delimiter
                will be discovered automatically between :
                {"," "\t" ";" "|" "\s"}.
  --no-header   If present, indicates that the CSV file hasn't header.
                Then the columns will be named 'column1', 'column2', and so on.
  -s SEPARATED_HEADER, --separated-header SEPARATED_HEADER
                Specify a separated header file that contains the header,
                its delimiter must be the same as the delimiter in the CSV file.
                Overrides --no-header.
  -q QUOTE_CHARACTER, --quote-character QUOTE_CHARACTER 
                The quote character surrounding the fields.
  --create      Creates the table in Hive.
                Overrides the previous Hive table, as well as its file in HDFS.
  --db-name DB_NAME
                Optional name for database where to create the Hive table.
  --table-name TABLE_NAME
                Specify a name for the Hive table to be created.
                If omitted, the file name (minus extension) will be used.
  --table-prefix TABLE_PREFIX
                Specify a prefix for the Hive table name.
  --table-suffix TABLE_SUFFIX
                Specify a suffix for the Hive table name.
  --table-external
                Ask to create an external Hive table.
  --load-from-hdfs HDFS_LOAD_LOCATION
                Ask to load the CSV file from this directory location in HDFS.
                CSV file must already exist in HDFS. This script will not modify HDFS.
  --parquet-create
                Ask to create the Parquet table.
  --parquet-db-name PARQUET_DB_NAME
                Optional name for database where to create the Parquet table.
  --parquet-table-name PARQUET_TABLE_NAME
                Specify a name for the Parquet table to be created.
                If omitted, the file name (minus extension) will be used.
  --parquet-table-prefix PARQUET_TABLE_PREFIX
                Specify a prefix for the Parquet table name.
  --parquet-table-suffix PARQUET_TABLE_SUFFIX
                Specify a suffix for the Parquet table name.
```

## Examples
### Example 1 (the simplest way to create a Hive table)

This example generates a 'CREATE TABLE' statement file in order to create a Hive table named 'airports' :
```
$ csv2hive --create ../data/airports.csv
```
Let's open the new generated Hive statement file named 'airports.hql', and note that the delimiter, the number of columns and the type for each column have been discovered automatically :
```
$ less airports.hql

DROP TABLE airports;
CREATE TABLE airports (
        Airport_ID int,
        Name string,
        City string,
        Country string,
        IATA_FAA string,
        ICAO string,
        Latitude float,
        Longitude float,
        Altitude int,
        Timezone float,
        DST string,
        Tz_db_time_zone string
)
COMMENT "The table [airports]"
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\,'
LOAD DATA LOCAL
INPATH '/home/user/Csv2Hive/test/airports.csv' OVERWRITE INTO TABLE airports;
```
If you don't want to create the table on Hive or if Hive is not installed on the same machine, don't use the '--create' option (anyway Cs2Hive will generates for you a '.hql' file).

### Example 2 (specifying a delimiter)
You can specify a delimiter but it's optional. Indeed, Csv2Hive already detects the following delimiters : Comma (","), Tab ("\t"), Semicolon (";"), Pipe ("|") and Space ("\s").
The example bellow specifies explicitly a tab delimiter, by using the TSV (Tab-Separated Values) file 'airports.tsv' :
```
$ csv2hive --create -d "\t" ../data/airports.tsv
```

### Example 3 (specifying the names for database and table)
You can specify the name of Hive database, and the Hive table's name as follows :
```
$ csv2hive --create --db-name "myDatabase" --table-name "myAirportTable" ../data/airports.csv
```

### Example 4 (create a Parquet table just after the Hive table)
You can create a Parquet table just after creating the Hive table as follows :
```
$ csv2hive --create --parquet-create --parquet-db-name "myParquetDb" --parquet-table-name "myAirportTable" ../data/airports.csv
```
Cs2Hive will generates the two 'CREATE TABLE' statement files '.hql' and '.parquet'.

### Example 5 (creating a Hive table in two steps)
It's possible first to generate the schema in order to modify the columns names, before to create the Hive table. This could be especially useful when the CSV file hasn't header :
```
$ csv2schema --no-header ../data/airports-no_header.csv
$ vi airports-no_header.schema
```
After modifying the columns names in the file named 'airports-no_header.schema', then you can generate the Hive 'CREATE TABLE' statement file as follows :
```
$ schema2hive ../data/airports-no_header.csv
```
Or you can create directly the Hive table as follows :
```
$ schema2hive --create ../data/airports-no_header.csv
```

### Example 6 (creating a Hive table with a separated header)
Sometimes you have to upload some big Dumps which consist in big CSV files (more than 100 GB) but without inner headers, also those files are often accompanied by a small separated file which describes the header. No problem, the only thing you will have to do before will be to create a short file containing the header in one line, by using the same delimiter as the one inside the Dump. Finally, you will just have to specify your new header file with the option '-s' as follows :
```
$ csv2hive.sh --create -s ../data/airports.header --table-name airports ../data/airports-noheader.csv
```
Trick: If you want to upload a big CSV file to HDFS with a different name as its original (e.g: 'airports.csv' rather 'airports-noheader.csv'), then it's nicer to create a symbolic link rather to make a copy.

### Example 7 (creating an external Hive table)
Sometimes you have to upload data to an external Hive table. This allows you to host the data in HDFS while Hive just manages the metadata. Furthermore, you are then able to transform and load data into another table using Map/Reduce if you need to. No problem, the only thing you will have to do is set the external table option with the HDFS directory containing the CSV file as follows :
```
$ csv2hive.sh --create --table-external "/tmp/hdfs_dir" ../data/airports.csv
```
Note: This tool does not interact with HDFS directly, it just instructs Hive to load the data from HDFS. You will need to upload and perform clean up in HDFS on your own.

### Example 8 (customizing Parquet options)
Sometimes you have to customize the load options for Parquet files. This allows you to override the default formats and compression behavior. No problem, the only thing you will have to do is set the parquet options as follows :
```
$ csv2hive.sh --create\
 --parquet-db-name "myParquetDb"\
 --parquet-table-name "myAirportTable"\
 --parquet-row-format "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"\
 --parquet-input-format "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"\
 --parquet-output-format "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"\
 --parquet-compression "none"\
 ../data/airports.csv
```
Note: This tool does not interact with HDFS directly, it just instructs Hive to load the data from HDFS. You will need to upload and perform clean up in HDFS on your own.

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif "Donate for Csv2Hive")]
(https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=Z2CBDC45UYGKN)
