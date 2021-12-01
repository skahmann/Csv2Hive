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
FIELDS TERMINATED BY '\,';
LOCATION '/tmp/hdfs_dir'
INPATH '/home/user/Csv2Hive/test/data/airports.csv' OVERWRITE INTO TABLE airports;
