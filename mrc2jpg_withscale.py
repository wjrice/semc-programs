#! /usr/bin/python

#import Image,ImageFile,ImageDraw,ImageFont,MrcImagePlugin
from PIL import Image,ImageFile,ImageDraw,ImageFont
import sys

if not sys.argv[3:]:
    print "Usage: mrc2jpg_withscale.py INPUT OUTPUT apixel"
    sys.exit(1)

sys.path.insert(1, '/data/cryoem/software/scripts')
import MrcImagePlugin

infile = sys.argv[1]
outfile = sys.argv[2]
apix = float(sys.argv[3])

im = Image.open(infile)
if im.mode== "F":
    im = im.convert2byte()


if apix >0:  #0 apix means don't draw the line
    barlengths=[10000,5000,2000,1000,500,200,100,50,20,10]  #nm
    barlength=barlengths[0]
    for  length in barlengths:  #want a barlength of at least 25 pixels
	pixel_barlength = int(length*10.0 / apix)
	ratio = pixel_barlength/100
	if (ratio > 1):
	    barlength=length

    pixel_barlength = int(barlength*10.0 / apix)
    text = "%d nm" %barlength

    #set up params for scalebar and label
    ystart = im.size[1]-30
    xstart = 30
    yend=ystart
    xend=xstart + pixel_barlength
    ytext = ystart+5
    barcolor=0
    backcolor=255
    default_font=ImageFont.load_default()
    fontsize=64
    #draw bar and text on top of while rectangle for clarity
    draw=ImageDraw.Draw(im)
    draw.rectangle((xstart-20,ystart-20,xend+20,yend+20),fill=backcolor)
    draw.line((xstart,ystart)+(xend,yend),fill=barcolor,width=4)
    draw.text((xstart,ytext),text,font=default_font,fill=barcolor)
    del draw

im.save(outfile)
