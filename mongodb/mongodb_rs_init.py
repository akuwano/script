#!/usr/bin/env python
import pymongo
from pymongo import Connection
from pymongo import ASCENDING, DESCENDING

import sys
import csv





try:
    file = sys.argv 
    print "file"
    print str(file[1]) 
    
    f = open(str(file[1]), 'rb')
    data = list(csv.reader(f))
    #print 'data'
    #print data
except Exception, e:
    print "CSV Input Error"
    print str(e)


for row in data:
    try:
        server = row[0].split(':')
        print 'server'
        print server[0]
        print server[1]
    except Exception, e:
        print "Split ERROR"
        print str(e)
    
    try:
        connection = Connection(str(server[0]), int(server[1]), slave_okay=True)
    except Exception, e:
        print "Server Connection ERROR"
        print str(e)
    
    
    config = {
        "_id": row[3],
        "members": [
        {"_id": 0, "host": row[0], "priority":2},
        {"_id": 1, "host": row[1], "priority":1},
        {"_id": 2, "host": row[2], "priority":0}]}
    
    try:
        print config
        #connection.admin.command("replSetInitiate",config)
    except Exception, e:
        print str(e)
        print "replSetInitiate Error. RS:"  + row[3]
    
    try:
        connection.admin.command("replSetGetStatus", 1)
    except Exception, e:
        print "replSetGetStatus Error"
        print str(e)
    
