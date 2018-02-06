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
import sys
import pdb
import re
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
import numpy as np
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

def plot_data(infile):
    data = infile.read()
    thickness = re.findall('.mrc thickness (.*?) nm',data,re.DOTALL)
    thickness = [float(thick) for thick in thickness]
    windowed_thickness = re.findall('windowed thickness (.*?) nm',data,re.DOTALL)
    windowed_thickness = [float(thick) for thick in windowed_thickness]
    mu = np.mean(thickness)
    sig = np.std(thickness)
    mu_w = np.mean(windowed_thickness)
    sig_w = np.std(windowed_thickness)
    
    f1, ax = plt.subplots(2,2)

    ax[0][0].scatter(range(len(thickness)),thickness,s=4,c='b')
    ax[0][0].set_xlabel('image#')
    ax[0][0].set_ylabel('ice thickness nm')
    ax[0][0].set_title('Ice Thickness')
    
    ax[0][1].scatter(range(len(windowed_thickness)),windowed_thickness,s=4,c="g")
    ax[0][1].set_xlabel('image#')
    ax[0][1].set_ylabel('ice thickness nm')
    ax[0][1].set_title('Windowned Ice Thickness')
    
    n,bins,patches = ax[1][0].hist(thickness,50,normed=1,facecolor='b',alpha=0.75)
    ax[1][0].set_xlabel('ice thickness nm')
    ax[1][0].set_ylabel('probability')
    ax[1][0].set_title('Histogram of Ice Thickness')
    ax[1][0].text(0.7, 0.9,  r'$\mu=%.1f,\ \sigma=%.1f$'%(mu,sig),ha='center',va='center',transform=ax[1][0].transAxes, fontsize=15)
    
    n,bins,patches = ax[1][1].hist(thickness,50,normed=1,facecolor='g',alpha=0.75)
    ax[1][1].set_xlabel('ice thickness nm')
    ax[1][1].set_ylabel('probability')
    ax[1][1].set_title('Histogram of Ice Thickness')
    ax[1][1].text(0.7, 0.9,  r'$\mu=%.1f,\ \sigma=%.1f$'%(mu_w,sig_w),ha='center',va='center',transform=ax[1][1].transAxes, fontsize=15)
    plt.tight_layout()
    f1.savefig('ice.pdf')
    
if len(sys.argv) ==1:

    outfile = open("ice.txt","w+")
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
       outfile.write("image %s thickness %f nm  windowed thickness %f nm" %(enna,thickness,thickness_win))
       
       plot_data(outfile)
       
elif len(sys.argv) ==2:
    try: 
        infile = open("ice.txt","r")
    except():
        print "Cannot find ice.txt"
        sys.exit()
        
    plot_data(infile)


   #print "image %s thickness %f nm" %(enna,thickness,)
#   print "%f" %(thickness)
 

