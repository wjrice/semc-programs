#! /usr/bin/env python
# -*- coding: utf-8 -*-

# program to print the header values of  tiff file collected on FEI Helios Nanolab 650
# does a few things to make output nicer (metric units)
# wjr 01-25-15

from PIL import Image
import re
import argparse
from math import pi,cos

# encoding=utf8 for micro symbol
import sys  
reload(sys)  
sys.setdefaultencoding('utf8')

fei_tag=34682 # this tag ID contains all the FEI header information in ascii format
keys=(
      ("Date",""),("HV","V"),("Beam",""),("HFW","m"),("ApertureDiameter","m"),("BeamCurrent","A"),
      ("DynamicFocusIsOn",""),("StageTa","radians"),("TiltCorrectionAngle","radians"),("Dwelltime","s"),
      ("PixelWidth","m"),("FrameTime","s"),("Integrate",""),("WorkingDistance","m"),("ResolutionX","pixels"),
      ("ResolutionY","pixels"))
metric = (' ','m', 'µ', 'n', 'p', 'f', 'a', 'z', 'y')

parser=argparse.ArgumentParser()
parser.add_argument("filename",help="Input filename")
parser.add_argument("-a", "--all", action="count",
                    help="print entire header")

args=parser.parse_args()

im=Image.open(args.filename)
header=im.tag[fei_tag]
if args.all >0:
   print header
else:
   for key in keys:
      match=re.search(re.escape(key[0]) + r"=(.*)\r\n",header)
      if key[1] != 'radians' :
         scientific=re.search(r'(\d+\.?\d*)e-(\d+)',match.group(1))
         if scientific: #outputs 'engineering' notation rather than scientific: assumes exponents negative and numbers positive
            mantissa=float(scientific.group(1))
            ordinate=int(scientific.group(2))
            toeven3 = (3- (ordinate %3)) %3
            ordinate += toeven3
            mantissa *= 10**toeven3
            ordinate /= 3
            print "%s: %.2f %s%s" %(key[0],mantissa, metric[ordinate],key[1])
         else: #decimals: no conversion needed
            print "%s: %s %s" %(key[0],match.group(1), key[1])
      elif match.group(1): #angle measurement: output in degrees if there is an angle listed
         degrees = 180.0 * float(match.group(1)) / pi
         print "%s: %s %s or %.1f degrees" %(key[0],match.group(1), key[1],degrees)

   # output corrected y pixel size if image was taken using defocus gradient
   df=re.search(r"DynamicFocusIsOn=yes\r\n",header)
   if df:
      tang=re.search(r"TiltCorrectionAngle=(.*)\r\n",header)
      pixwidth=re.search(r"PixelWidth=(.*)\r\n",header)
      tang=abs(float(tang.group(1)))
      corr_ypix= float(pixwidth.group(1))/cos(tang) *1E9   # convert to nm
      print "Corrected y-pixel size: %.2f nm" %corr_ypix



