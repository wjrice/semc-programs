#! /usr/bin/env python
# python script to pparse a json file and output picks to a star file
# run in a loop to get many files
# arguement 1: json file
# argument 2: output star file
#
# example loop
# for f in 22sep15d*.json; do /data/cryoem/software/scripts/count_holes.py $f 22sep15d_holes.star; done

# creates new star file, or appends if it already exists
# wjr 10-08-22

import json
import sys
import os.path
myfile = sys.argv[1]
mystarfile = sys.argv[2]
#print myfile
f = open(myfile)
if os.path.isfile(mystarfile):
	f2 = open(mystarfile,'a')
else:
	f2 = open(mystarfile,'w')
	f2.write("data_\n")
	f2.write("\n")
	f2.write("loop_\n")
	f2.write("_rlnCoordinateX #1\n")
	f2.write("_rlnCoordinateY #2\n")
	f2.write("_rlnMicrographName #3\n")
len2 = len(myfile)
mrcfile = myfile[:len2 - 5]
data=json.load(f)
l=len(data)
print ("%s: found number of holes: %i" %(myfile,l))
for item in data:
	center = item['center']
	x = center[0]
	y=center[1]
	f2.write("%i %i %s\n"%(x,y,mrcfile))
