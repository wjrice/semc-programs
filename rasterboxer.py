#!/usr/bin/env python
# script to raster a box
# needs to be using EMAN2 finctions to get boxsize
#  Usage
# genlist.py --mrcfile=<STARFILE> --size=<SPARXLIST> --offset=<OUTPUTSTAR>
# default size is 256
# default offset is 0, which means boxes are touching
# border option to eliminate boxes right at the edge of micrograph

# outputs
#  boxfile with same filename as mrc file, replacing .mrc with .box
# wjr 02-13-2019

import os.path
from optparse import OptionParser
try:
   from EMAN2 import *
except:
   print "Need to have EMAN2 envoronment loaded"


def GetData():
   parser=OptionParser()
   parser.add_option("--mrcfile", dest="mrcfile", help="mrcfile default=test.mrc", default='test.mrc',metavar="INPUT_MRCFILE")
   parser.add_option("--boxsize", dest="boxsize", help="boxsize default=256", default = 256, metavar="BOXSIZE")
   parser.add_option("--offset", dest="offset", help="offset between boxes, default=0, negative for overlap", default = 0, metavar="OFFSET")
   parser.add_option("--border", dest="border", help="micrograph border, default=0", default = 0, metavar="BORDER")
   (options, args) = parser.parse_args()
   return (options.mrcfile,options.boxsize,options.offset,options.border)

(mrcfile,boxsize,offset,border)=GetData()
boxsize = int(boxsize)
offset = int(offset)
border = int(border)

fileName, fileExtension = os.path.splitext(mrcfile)
boxname = fileName + '.box'
fout = open(boxname,"w")
header = EMData();
header.read_image(mrcfile, 0, True)
nx = header.get_attr('nx')
ny = header.get_attr('ny')

boxX = border    #EMAN boxfile specify the lower left corner. We will go to the edge
boxY = boxsize + border
maxX = nx - boxsize - border
maxY = ny - border

while boxX <= maxX:
   while boxY <= maxY:
      fout.write ('%i     %i     %i     %i     %i\n' %(boxX, boxY, boxsize, boxsize, -3))
      boxY +=  boxsize + offset
   boxY  = boxsize  + border
   boxX += boxsize + offset



