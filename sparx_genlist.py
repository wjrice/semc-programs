#! /bin/env python
# script to parse all sparx isac generation files (accounted and unaccounted)
# to generate final file listing the accounted-for particles
# need to copy all of these files into a directory and name accordingly:
#   generation_01_accounted.txt
#   generation_01_unaccounted.txt
#   generation_02_accounted.txt
#   generation_02_unaccounted.txt
#   generation_03_accounted.txt
#... etc

#  Usage
# genlist.py --stack inputstack.hdf <--select 1>
# where inputstack is original particle stack for first run of ISAC
# if --select option is selected, then inout files will be generation_NN_accounted_selected.txt
# this is for sparx class selection

# outputs
#   all_accounted.lst -- the list of all particles
#   generation_NN.lst -- the list of particles BEFORE running generation NN (ie input to NN) according to orig stack numbering
# wjr 03-13-2016

import os.path
from EMAN2  import *
from sparx  import *
from optparse import OptionParser

max=30  # max numbers of generations to find

def GetData():
   parser=OptionParser()
   parser.add_option("--stack", dest="stack", help="original particles stack ", metavar="STACK")
   parser.add_option("--select", dest="select", help="selected particles option ", default = 0, metavar="STACK")
   (options, args) = parser.parse_args()
   return (options.stack,options.select)

(stack,select)=GetData()
gen=1
if select:
   accfile="generation_%.2d_accounted_selected.txt" %gen
   rejfile="generation_%.2d_unaccounted_selected.txt" %gen
else:
   accfile="generation_%.2d_accounted.txt" %gen
   rejfile="generation_%.2d_unaccounted.txt" %gen

lstfile="generation_%.2d.lst" %gen
#stack = stack[0]
orignum = EMUtil.get_image_count(stack)
outfile="all_accounted.lst"

particles = range(orignum) # oriignal list of all particles
good=[]

while (os.path.isfile(accfile) and os.path.isfile(rejfile)):
   with open(accfile) as f:
      acc = f.readlines()
   with open(rejfile) as f:
      rej = f.readlines()
   with open(lstfile,"w") as fout:
      for pnum in particles:
         fout.write("%i\n"%pnum)
   for i in range(len(acc)):
      acc[i]=int(acc[i])
   for i in range(len(rej)):
      rej[i]=int(rej[i])
   for i in range(len(acc)):
      good.append(particles[acc[i]])
   newparticles=[]
   for i in range(len(rej)):
      newparticles.append(particles[rej[i]])
   particles=newparticles
   gen += 1
   accfile="generation_%.2d_accounted.txt" %gen
   rejfile="generation_%.2d_unaccounted.txt" %gen
   lstfile="generation_%.2d.lst" %gen
 
good.sort()
with open(outfile,"w") as fout:
   for pnum in good:
      fout.write("%i\n"%pnum)

