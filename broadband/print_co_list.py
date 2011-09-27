# python script to spit out the county boundaries list, rounded to .00, etc. 

import psycopg2
# db credentials
db_name = 'tracts'
db_user = 'irw_postgres'
db_host = 'localhost'
db_pass = 'w0rksh0p'



# Connect to the db: 

dbconnectstring = "dbname='%s' user='%s' host='%s' password='%s'" % (db_name, db_user, db_host, db_pass) 

# Connect to db, get a cursor, execute query
try:
    conn = psycopg2.connect(dbconnectstring);
except:
    print "I am unable to connect to the database"
cur = conn.cursor()

db_query = "select state || county, floor(1000.0*st_xmin(the_geom))/1000 as xmin, ceil(1000.0*st_xmax(the_geom))/1000 as xmax, floor(1000.0*st_ymin(the_geom))/1000 as ymin, ceil(1000.0*st_ymax(the_geom))/1000 as ymax from counties_s2;"


cur.execute(db_query)
rows = cur.fetchall()


# open a file to dump all the new shapes to:
dumpfile = 'colist.txt'
OUT = open(dumpfile, 'w')

OUT.write("var colist:Array = [")
first_row = 1
#['42049',-80.52 ,-79.6, 41.84, 42.27], ['42015', -76.93, -76.11, 41.54, 42.01]];
for row in rows:
    if first_row==0:
        OUT.write(", ")
    OUT.write("['%s',%s ,%s, %s,%s]" % (row[0], row[1], row[2], row[3], row[4]))
    first_row=0
    
OUT.write("];\n")