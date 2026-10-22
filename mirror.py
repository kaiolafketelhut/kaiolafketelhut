import psycopg2, pymongo
pg = psycopg2.connect("dbname=termuxDB user=oeneye password=oeneye host=127.0.0.1")
rows = pg.cursor(); rows.execute("SELECT * FROM test;"); data=rows.fetchall()
print(f"Postgres: {data}")
m = pymongo.MongoClient("mongodb://127.0.0.1:27017/", serverSelectionTimeoutMS=2000)
m.admin.command('ping')
db=m.oeneye; db.test_mirror.delete_many({})
for r in data: db.test_mirror.insert_one({"id":r[0],"name":r[1]})
print(f"Mongo: {list(db.test_mirror.find({}, {'_id':0}))} CO-CONTAINER OK!")
