#! /bin/env python
# to get ice thickness from mean values of images by comparing with  intensity

import global_def
from global_def import *
from glob import glob as glob
from math import log # natural log
#from EMAN2 import * 
from optparse import OptionParser


def GetData():
   parser=OptionParser()
   parser.add_option("--mfp", dest="mfp", help="default=300", default=300,metavar="MEAN_FREE_PATH")
   parser.add_option("--type", dest="img_type", help="default=enn-a", default = 'enn-a', metavar="IMAGE_TYPE")
   parser.add_option("--vac", dest="Ivac", help="default=10", default = 10, metavar="VACUUM_INTENSITY")
   (options, args) = parser.parse_args()
   return (options.mfp,options.img_type,options.Ivac)


(mfp,ennastring,Ivac) = GetData()
mfp = float(mfp)
Ivac = float(Ivac)

##ennastring='esn-a'  # preset name for exposure
filestring = '*' + ennastring + '*.mrc'
icelist = glob(filestring)
icelist.sort()
img_u=EMData()  #placeholder for loading unfilt images
##mfp = 3329

##Ivac = 9.16
for image in icelist:
   try: 
      img_u.read_image(image,0,True) # read only  header
   except (RuntimeError, TypeError, NameError):
      print "error reading %s" %image
      next
   I = img_u.get_attr('MRC.mean')
   thickness = log (Ivac/I)
   calc = thickness * mfp
   print "image %s thickness %f calc_thickness %f" %(image,thickness,calc);
   #print "image %s thickness %f nm" %(enna,thickness,)
#   print "%f" %(thickness)

 

