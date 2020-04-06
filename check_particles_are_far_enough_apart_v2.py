#!/usr/bin/env python
## Scripted by Yong Zi Tan
## 2 January 2017
## v2: added parser options
## check_particles_are_far_enough_apart_v2.py -h for options

import sys
import os
from math import sqrt
import os.path
from optparse import OptionParser


def GetData():
   parser=OptionParser()
   parser.add_option("--subdir", dest="subdir", help="default=micrographs", default='micrographs',metavar="PARTICLES_SUBDIRECTORY")
   parser.add_option("--dist", dest="dist", help="default=20", default = 20, metavar="MINIMUM_OVERLAP_DISTANCE_FOR_DELETION")
   parser.add_option("--save", dest="save", help="default=yes", default = 'yes', metavar="SAVE_OUTPUT yes/no")
   parser.add_option("--xcol", dest="xcol", help="default=1", default = 1, metavar="RELION_XCOLUMN")
   parser.add_option("--ycol", dest="ycol", help="default=2", default = 2, metavar="RELION_YCOLUMN")
   (options, args) = parser.parse_args()
   options.dist = int(options.dist)
   options.xcol = int(options.xcol)
   options.ycol = int(options.ycol)
   options.xcol -= 1  #relion counts from 0
   options.ycol -= 1
   return (options.subdir,options.dist,options.save,options.xcol,options.ycol)

def calculate_distance(p1,p2):
    return sqrt((p2[0] - p1[0]) ** 2 + (p2[1] - p1[1]) ** 2)

(input_dir,distance,savefile,Xcolumn,Ycolumn) = GetData()

print ("Your input directory is: " + input_dir)
print ("Your maximum inter-particle distance in pixels: " + str(distance))
print ("X coordinates are in column number " + str(Xcolumn))
print ("Y coordinates are in column number " + str(Ycolumn))

## Read directory
a = os.listdir(input_dir)
extractstarfiles = []
for i in a:
	if (i[-12:] == "extract.star"):
		extractstarfiles.append(i)

## Read the star file in
badparticlepaircounter = 0
goodparticlescounter = 0
removedparticlescounter = 0
if (savefile == "yes"):
	outputcombined = open("particlesNew.star","w")
	outputcombinedheader = 0
for i in extractstarfiles:
	starfile = []
	starfilefull = []
	header = []
	headercounter = 0
	a = open(os.path.join(input_dir,i), "r")
	b = a.readlines()
	for j in b:
		if (len(j.split()) > 2 and j.split()[0][0] !=  '#'):
			k = j.split()
			starfile.append([int(float(k[Xcolumn])),int(float(k[Ycolumn]))])
			starfilefull.append(j)
			headercounter = 1
		elif (headercounter == 0):
			header.append(j)
		else:
			whitespace = 0  ##whitespace gone
	scoringarray = [0]*len(starfile)
	if (range(len(starfile)) > 1): ## If only 1 particle, skip
		for j in range(len(starfile)):
			reference = starfile.pop(0)
			counter = 1
			for k in starfile:
				calculated_distance = calculate_distance(reference,k)
				if (calculated_distance < distance):
					print (str(i) + " has two particles that are too close! Coordinates are " + str(reference) + " and " + str(k) + " and they are " + str(calculated_distance) + " pixels apart only.")
					badparticlepaircounter += 1
					scoringarray[counter+j] += 1
				counter += 1
	if (savefile == "yes"):
		if (outputcombinedheader == 0):
			for j in header:
				outputcombined.write(j)
			outputcombinedheader += 1 # write header only once
		output = open(os.path.join(input_dir,i[:-5] + "New.star"),"w")
		for j in header:
			output.write(j)
		for j in range(len(starfilefull)):
			if (scoringarray[j] == 0):
				output.write(starfilefull[j])
				outputcombined.write(starfilefull[j])
				goodparticlescounter += 1
			else:
				removedparticlescounter += 1
	output.write("\n")
	output.close()
outputcombined.write("\n")
outputcombined.close()
	
print ("Total number of particle pairs that are too close: " + str(badparticlepaircounter))
print ("Particles removed: " + str(removedparticlescounter))
if (savefile == "yes"):
	print ("particlesNew.star has been written with " + str(goodparticlescounter) + " unique particles.")
print ("Done")

