-- Getting source roads data 
SELECT osm_id, bicycle, highway, name, ST_AsText(ST_Transform(way,4326)) FROM public.planet_osm_line WHERE highway is not NULL AND
way && ST_Transform(ST_SetSRID('BOX3D(37.05 55.05,37.91 55.91)'::box3d,4326),900913); 

-- Compute source csv with SRTM data (roads.py)

--DROP TABLE roads_hills

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
 
-- Index: roads_hills_the_geom_gist
CREATE INDEX roads_hills_the_geom_gist
  ON roads_hills
  USING gist
  (way);
  
-- Import csv data into table
COPY roads_hills(osm_id,bicycle,highway,name,angle,a_height,d_height,dist,lines) FROM '/users/karmatsky/hills/export_roads_only.csv' DELIMITERS ';' CSV

-- Convert linestring coordinates into geometry
UPDATE roads_hills SET way = ST_Transform(ST_GeomFromText('LINESTRING(' || lines || ')',4326), 900913);

 

