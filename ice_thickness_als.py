#! /bin/env python
# to get ice thickness from mean values of images by comparing with  intensity
# wjr 
# from  
# Rice WJ, Cheng A, Noble AJ, Eng ET, Kim LY, Carragher B, Potter CS. 
# Routine determination of ice thickness for cryo-EM grids. J Struct Biol. 2018
# Oct;204(1):38-44. doi: 10.1016/j.jsb.2018.06.007. Epub 2018 Jul 4. PubMed PMID:
# 29981485; PubMed Central PMCID: PMC6119488.

import global_def
from global_def import *
from glob import glob as glob
from math import log # natural log
from EMAN2 import * 
from optparse import OptionParser


def GetData():
   parser=OptionParser()
   parser.add_option("--mfp", dest="mfp", help="default=300", default=300,metavar="MEAN_FREE_PATH")
#   parser.add_option("--type", dest="img_type", help="default=enn-a", default = 'enn-a', metavar="IMAGE_TYPE")
   parser.add_option("--vac", dest="Ivac", help="default=10", default = 10, metavar="VACUUM_INTENSITY")
   parser.add_option("--outfile", dest="outfile", help="default=thickness.txt", default = 'thickness.txt', metavar="OUTPUT FILE")
   parser.add_option("--filetype", dest="filetype", help="default=mrc", default = 'mrc', metavar="FILETYPE")
   (options, args) = parser.parse_args()
   #return (options.mfp,options.img_type,options.Ivac)
   return (options.mfp,options.Ivac,options.outfile,options.filetype)


(mfp,Ivac,outfile,filetype) = GetData()
mfp = float(mfp)
Ivac = float(Ivac)

filestring = '*.' + filetype
icelist = glob.glob(filestring)
icelist.sort()
img_u=EMData()  #placeholder for loading unfilt images
f=open(outfile,'w')
for image in icelist:
   try: 
      img_u.read_image(image,0,True) # read only  header
   except (RuntimeError, TypeError, NameError):
      print "error reading %s" %image
      next
   I = img_u.get_attr('MRC.mean')
   thickness = log (Ivac/I)
   calc = thickness * mfp
   f.write("image %s  calc_thickness (nm)  %.1f\n" %(image,calc))

 

