#! /bin/env python
# to get ice thickness from mean values of images with and without energy filter
# theory: Thickness/MFP = log (It/Izl)
# MFP = electron mean free path in ice
# Izl = zero-loss peak intensity
# It = total spectrum intensity
# APPROXIMATION: Use ennergy-filtered mean intensity as I0
#                Use image intensity without slit as It
# mean free path estimate from paper: need to verify experimentally
# by comparing calculated values with geometrically detrmined values
# Geometry: by tomogram (Alex Noble) or Berriman +30 -30 image pairs

import global_def
from global_def import *
from glob import glob as glob
from math import log # natural log
#from EMAN2 import * 

exp_enn=1.00 # length of image exposure
exp_ith = 1.0 # length of unfiltered exposure
# ith: 6.602 enn: 64.426
factor = exp_ith/exp_enn # correction factor

mfp = 395 # mean free path of electrons, in nm
icestring='ith' #preset name for non-zero-loss images
ennastring='jnk'  # preset name for 'zero loss' 10-20 eV slit width images
filestring = '*' + icestring + '*.mrc'
icelist = glob(filestring)
icelist.sort()
img_u=EMData()  #placeholder for loading unfilt images
img_f=EMData()  #placeholder for loading filt images
new_nx=512  #following are window parameters
new_ny=512
new_nz=1
ix=0
iy=0
iz=0

for image in icelist:
   enna=image.replace(icestring,ennastring)
   try: 
      img_u.read_image(image,0,) # read image plus header
   except (RuntimeError, TypeError, NameError):
      print "error reading %s" %image
      next
   It = img_u.get_attr('MRC.mean')
   try:
      img_f.read_image(enna,0,)
   except (RuntimeError, TypeError, NameError):
      print "error reading %s" %enna
      next
   Izl = img_f.get_attr('MRC.mean')
   Izl *= factor  # scale intensities according to exposure time
   thickness = mfp * log (It/Izl)
   win_img_u = Util.window(img_u, new_nx, new_ny)    #, new_nz ,ix, iy, iz)
   win_img_f = Util.window(img_f, new_nx, new_ny)    #, new_nz ,ix, iy, iz)
   win_img_f.update()
   win_img_u.update()
   Izl_win =  win_img_f.get_attr('mean')
   It_win =  win_img_u.get_attr('mean')
   Izl_win *= factor
   thickness_win = mfp * log (It_win/Izl_win)
   print "image %s thickness %f nm  windowed thickness %f nm" %(enna,thickness,thickness_win)
   #print "image %s thickness %f nm" %(enna,thickness,)
#   print "%f" %(thickness)
 

