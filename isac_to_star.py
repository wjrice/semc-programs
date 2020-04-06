#!/usr/bin/env python
# script to edit a star file to keep only the good particles from an ISAC run

#  Usage
# genlist.py --starfile=<STARFILE> --list=<SPARXLIST> --output=<OUTPUTSTAR>
# default starfile is particles.star
# default list is isac_substack_particle_id_list.txt

# outputs
#   default isac_particles.star -- starfile containing only the good particles as selected by ISAC
# wjr 12-02-2017

import os.path
from optparse import OptionParser


def GetData():
   parser=OptionParser()
   parser.add_option("--starfile", dest="starfile", help="default=particles.star", default='particles.star',metavar="INPUT_STARFILE")
   parser.add_option("--list", dest="isac_list", help="default=isac_substack_particle_id_list.txt", default = 'isac_substack_particle_id_list.txt', metavar="ISAC_LIST")
   parser.add_option("--output", dest="outstar", help="default=isac_particles.star", default = 'isac_particles.star', metavar="OUTPUT_STARFILE")
   (options, args) = parser.parse_args()
   return (options.starfile,options.isac_list,options.outstar)

(starfile,isac_list,outstar)=GetData()
with open (starfile,'r') as fin:
   starlines=fin.readlines()
fin.close()
with open (isac_list,'r') as fin:
   isac_sel=fin.readlines()
fin.close()

fout=open(outstar,"w")
stardata=[]
for line in starlines:
   data=line.split()
   if len(data) < 3: #assuming all stardata has at least 3 items, basically this just writes the header
      fout.write("%s" %line)
   else:
      stardata.append(line)
 
for key in isac_sel:
   key = int(key)
   fout.write("%s" %stardata[key])



