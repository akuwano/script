#!/usr/bin/env python
import pymongo
from pymongo import Connection
from pymongo import ASCENDING, DESCENDING

import csv

try:
    f = open('mongodb.csv', 'rb')
    data = list(csv.reader(f))
except:
    print "CSV File ERROR"


for row in data:
    try:
        server = row[0].split(':')
        #connection = Connection('ec2-46-51-232-225.ap-northeast-1.compute.amazonaws.com', 27017)
        connection = Connection(server[0], server[1], slave_okay=True)
    except:
        print "Server Connection ERROR"
    
    
    config = {
        "_id": "row[3]",
        "members": [
        {"_id": 0, "host": "row[0]", "priority":2},
        {"_id": 1, "host": "row[1]", "priority":1},
        {"_id": 2, "host": "row[2]", "priority":0}]}
    
    posts = db.posts
    posts.insert(post)
    connection.admin.command("replSetInitiate : config")
    try:
        print config
        #connection.admin.command("replSetInitiate",config)
    except:
         print "caught"
    #connection.admin.command("replSetGetStatus",1 )
    
    #db.collection_names()







