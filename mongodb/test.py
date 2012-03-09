#!/usr/bin/env python
import pymongo
from pymongo import Connection
from pymongo import ASCENDING, DESCENDING

import sys
import csv



server = [ '10.200.1.1' , '27218']

try:
    print server[0]
    print server[1]
    connection = Connection(str(server[0]), server[1], slave_okay=True)
    #connection = Connection("10.200.1.1" ,27218, slave_okay=True)
    #connection = Connection('ec2-46-51-232-225.ap-northeast-1.compute.amazonaws.com', 27017)
except Exception, e:
    print str(e)
    print "Server Connection ERROR"
