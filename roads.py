import struct
from math import radians, cos, sin, asin, sqrt, atan, degrees

srtm_file = "data/N55E037.hgt"
import_file = "data/import_file.csv"
export_file = "data/export_file.csv"

def get_distance(lon1, lat1, lon2, lat2):
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a)) 
    m = 6367594 * c
    return round(m,2)

with open(srtm_file, "rb") as hgt:

    def get_height(lon,lat):
		if(lat>55.99): return 0
		if(lon>37.99): return 0
		n = (float(lat) - 55) * 3600 #convert longitude to arc-seconds
		e = (float(lon) - 37) * 3600 #convert latitude to arc-seconds
		i = 1201 - int(round(n / 3, 0))
		j = int(round(e / 3, 0))
		hgt.seek(((i - 1) * 1201 + (j - 1)) * 2)  # go to the right spot,
		buf = hgt.read(2)  # read two bytes and convert them:
		val = struct.unpack('>h', buf)  # ">h" is a signed two byte integer
		if not val[0] == -32768:  # the not-a-valid-sample value
			return val[0]
		else:
			return None


    with open(export_file, "w") as export:  
        with open(import_file) as source:
            for line in source:
                lst = line.split(';')  
                osm_id = lst[0].strip()
                bicycle = lst[1].strip()
                highway = lst[2].strip()
                name = lst[3]
                coords_list = lst[4].strip().replace("LINESTRING(","").replace(")","").split(",")
                for i in range(len(coords_list)-1):
                    #computing parameters
                    co1 = coords_list[i].split(' ')
                    co2 = coords_list[i+1].split(' ')
                    lon1 = float(co1[0])
                    lat1 = float(co1[1])
                    lon2 = float(co2[0])
                    lat2 = float(co2[1])
                    h1 = get_height(lon1,lat1)
                    h2 = get_height(lon2,lat2)
                    dh = abs(h1 - h2)
                    ah = int((h1+h2)/2)
                    distance = get_distance(lon1,lat1,lon2,lat2) #computing distance without elevation
                    correct_distance = int(sqrt(distance**2 + dh**2))
                    angle = int(degrees(atan(dh/distance))) #computing angle
                    
                    if (h1<=h2):
                        export_coords_string = "%s %s, %s %s" % (lon1,lat1,lon2,lat2)
                    else:
                        export_coords_string = "%s %s, %s %s" % (lon2,lat2,lon1,lat1)

                    export_string = "%s;%s;%s;%s;%i;%i;%i;%i;%s" % (osm_id, bicycle, highway, name, angle, ah, dh, correct_distance,export_coords_string)
                    #print export_string
                    export.write(export_string + '\r'),
