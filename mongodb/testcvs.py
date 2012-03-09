#!/usr/bin/env python
import csv

f = open('mongodb.csv', 'rb')
data = list(csv.reader(f))

import collections
counter = collections.defaultdict(int)
for row in data:
     print row[0]
     print row[1]
     print row[2]
     print row[3]
for row in data:
    if counter[row[1]] >= 4:
        writer = csv.writer(open("test1.csv", "wb"))
        writer.writerows(row)

