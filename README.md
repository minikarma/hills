### Hello hills
The tiny project mapping elevation in Moscow. The map using Openstreetmap and SRTM3 data. Result of work at <http://getwalk.me/hills>

The tools you need to get the same map are:

  *  [PostgreSQL](http://www.postgresql.org/) with [PostGIS](http://postgis.net/) as data local storage
  *  [osm2pgsql](http://wiki.openstreetmap.org/wiki/Osm2pgsql) tool to import OSM data to local
  *  Any Python interpreter
  *  [TileMill](https://www.mapbox.com/tilemill/)
  
  
####Get the source data
Download OSM data extracts and import it into PostgreSQL. Use any [Planet.osm](http://wiki.openstreetmap.org/wiki/Planet) source you like.

Get proper SRTM [data](http://dds.cr.usgs.gov/srtm/version2_1/). In my case I used SRTM3 data (Eurasia).
  
####Process data
 
Export roads data to CSV format. See `queries.sql`.
```
SELECT osm_id, bicycle, highway, name, ST_AsText(ST_Transform(way,4326)) FROM public.planet_osm_line WHERE highway is not NULL AND
way && ST_Transform(ST_SetSRID('BOX3D(37.05 55.05,37.91 55.91)'::box3d,4326),900913);
```

Despite OSM data stored in Google Mercator (SRID: 90013) I used WGS84 (SRID: 4326). Decimal degrees easier to read and convert values to arc-seconds.

Configure input parameters in `roads.py` script and run it. Sorry it's my first python script, I'm not a developer. 
The script will open CSV data and SRTM file (.hgt) and will create export CSV-file with processed lines. 

```
python roads.py
```

The polylines will be splited to simple short lines with only two coordinates, the lowest coordinate will be the first.

The script computes following parameters for each line:

  *  the average elevation of this line (average value of coordinates elevetion)
  *  tilt angle
  *  length of this line


Come back to PostgreSQL with computed data and import it into new table.

Create a table:

```
--Create new table
CREATE TABLE roads_hills
(
  rid serial NOT NULL,
  osm_id text,
  bicycle text,
  highway text,
  name text,
  angle smallint,
  a_height smallint,
  d_height smallint,
  dist smallint, 
  lines text,
  way geometry,
  	CONSTRAINT roads_hills_pkey PRIMARY KEY (rid),
	CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(way) = 2),
	CONSTRAINT enforce_geotype_geom CHECK (geometrytype(way) = 'LINESTRING'::text OR way IS NULL),
	CONSTRAINT enforce_srid_way CHECK (st_srid(way) = 900913)
);
 
CREATE INDEX roads_hills_the_geom_gist
  ON roads_hills
  USING gist
  (way);
```


Import data from CSV file:

```
COPY roads_hills(osm_id,bicycle,highway,name,angle,a_height,d_height,dist,lines) FROM 'export_file.csv' DELIMITERS ';' CSV
```

Convert linestring coordinates from string values to geometry column:
```
UPDATE roads_hills SET way = ST_Transform(ST_GeomFromText('LINESTRING(' || lines || ')',4326), 900913);
```




####Design map

TBD
