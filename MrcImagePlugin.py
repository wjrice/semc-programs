# MRC image file handling
# read an mrc file into a std image
# currently limited to 2D files
# reads in 8-bit, 16-bit signed, 16-bit unsigned, and 32-bit float images
# does not recognize complex formats
# checks little endian and then big-endian if little-endian fails

#example:
#  s=Image.open("sample.mrc")
#  s.convert2byte()
#  s.save("sample.jpg")

# Adapted from SpiderImagePlugin.py by William Baxter

# 2010-07-25 William Rice

import struct, sys
from PIL import Image, ImageFile

def isInt(f):
    try:
        i = int(f)
        if f-i == 0: return 1
        else:        return 0
    except:
        return 0

# There is no magic number to identify MRC files, so just check a
# series of header locations to see if they have reasonable values.
# Fro now, just check image size and mode (first four long ints)
# Returns 1 if it is a valid MRC header, otherwise returns 0
mrc_modes = [0,1,2,6]

def isMrcHeader(t):
    # header values 0,1,2,3 should be integers
    if not isInt(t[0]): return 0
    if not isInt(t[1]): return 0
    if not isInt(t[2]): return 0
    if not isInt(t[3]): return 0
    # check mode
    mode = int(t[3])
    if not mode in mrc_modes: return 0
    # looks like a valid header
    print "size = %d,%d,%d" % (t[0],t[1],t[2])
    print "mode = %d" %t[3]
    print "map =  %d" %(t[52])
    print "machine type = %d" %t[53]
    return 1

def isMrcImage(filename):
    fp = open(filename,'rb')
    f = fp.read(224)    #read 56 * 4 bytes
    fp.close()
    t = struct.unpack('56l',f)
    if isMrcHeader(t):
	return 1
    else:
	return 0

def printMrcTitle(n,t):
    #prints the first n titles in an MRC image
    chars = struct.unpack('800c',t)
    print "Titles:"
    for i in range(n):
	title="".join(chars[(i*80):(i+1)*80])
	print "%d\t%s" %(i+1,title)
    print

class MrcImageFile(ImageFile.ImageFile):
    format = "MRC"
    format_description = "MRC image"

    def _open(self):
	n = 56 *4
	f = self.fp.read(n)
	try:
	    t=struct.unpack('<56l',f)  # try little-endian first
	    if isMrcHeader(t):
		endian=''
		print "MRC file in little-endian format"
	    else:
		t=struct.unpack('>56l',f)  #failed, so try big-endian
		if isMrcHeader(t):
		    endian='B'
		    print "MRC file in big-endian format"
		else:
		    raise SyntaxError + ' not a valid MRC file'
	except struct.error:
	    raise SyntaxError + ' not a valid MRC file'
	f = self.fp.read(800)  #read title info
	printMrcTitle(t[55],f)  #last word is number of titles
	self.size=int(t[0]),int(t[1])
	zsize = int(t[2])
	if zsize != 1:
	    print "zsize = %d"%zsize
	    raise SyntaxError, "Can only read 2D images for now!"
	mrcimagetype=t[3]  
	#types: 0: 8-bit signed, 1:16-bit signed, 2: 32-bit float, 6: unsigned 16-bit (non-std Leginon)
	if (mrcimagetype == 0):
	    self.rawmode =  'L'
	    self.mode = "L"
	elif (mrcimagetype == 1):
	    self.rawmode =  'F;16' + endian + 'S'
	    self.mode = "F"
	elif (mrcimagetype == 2):
	    self.rawmode =  'F;32' + endian + 'F'
	    self.mode = "F"
	elif (mrcimagetype == 6):
	    self.rawmode =  'F;16' + endian
	    self.mode = "F"
	else:
	    raise SyntaxError, "Not a recognized MRC file!"
	self.tile = [
		('raw',(0,0) + self.size, 1024,(self.rawmode,0,-1))
		] #-1 means 1st line of data is at bottom of screen, which is MRC standard

# returns a byte image after rescaling to 0..255
    def convert2byte(self, depth=255):
        (min, max) = self.getextrema()
        m = 1
        if max != min:
            m = depth / (max-min)
        b = -m * min
        return self.point(lambda i, m=m, b=b: i * m + b).convert("L")

Image.register_open("MRC", MrcImageFile)
Image.register_extension("MRC", ".mrc")
if __name__ == "__main__":

    if not sys.argv[2:]:
        print "Syntax: python MrcImagePlugin.py image.mrc image.(png,jpg,tif,..) -- to convert an image"
        sys.exit(1)

    filename = sys.argv[1]

    im = Image.open(filename)
    print "image: " + str(im)
    print "size: " + str(im.size)
    print "mode: " + str(im.mode)
    print "max, min: ",
    print im.getextrema()
    if im.mode== "F":
        im = im.convert2byte()
    im.save(sys.argv[2])
