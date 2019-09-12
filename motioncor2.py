#!/usr/bin/env python
# script to run motioncorr2 manually
# run with -h to get params
# useful for rescaling
# wjr 051518 from Misha

import os
from optparse import OptionParser

def GetData():
   parser=OptionParser()
   parser.add_option("--format", dest="format", help="default=mrc, other option tif", default='mrc',metavar="File Format")
   parser.add_option("--filelist", dest="filelist", help="default=files.txt", default='files.txt',metavar="File list")
   parser.add_option("--framedir", dest="framedir", help="default=./", default='./',metavar="Frames directory")
   parser.add_option("--alidir", dest="alidir", help="default=./ali/", default='./ali/',metavar="Output aligned directory")
   parser.add_option("--gain", dest="gain", help="default=gain_mod.mrc", default='gain_mod.mrc',metavar="Gain correction file")
   parser.add_option("--flipgain", dest="flipgain", help="default=1", default=1,metavar="FlipGain value")
   parser.add_option("--rotgain", dest="rotgain", help="default=0", default=0,metavar="RotGain value")
   parser.add_option("--ftbin", dest="ftbin", help="default=1.00", default = 1.0, metavar="Fourier binning factor")
   parser.add_option("--pixsize", dest="pixsize", help="default=1.06", default = 1.06, metavar="Input pixel size (A)")
   parser.add_option("--fmdose", dest="fmdose", help="default=1.0", default=1.0, metavar="electron dose per frame")
   parser.add_option("--gpu", dest="gpu", help="default=0", default = 0, metavar="GPU to use")
   parser.add_option("--throw", dest="throw", help="default=0", default = 0, metavar="start frames to delete (0=keep all)")
   parser.add_option("--kv", dest="kv", help="default=300", default = 300, metavar="voltage of microscope")
   parser.add_option("--patch", dest="patch", help="default='5 5'", default = '5 5', metavar="patch size, use quotes")
   #parser.add_option("--bft", dest="bft", help="default=100", default = 100, metavar="B factor")
   (options, args) = parser.parse_args()
   return (options.format,options.filelist,options.framedir,options.alidir,options.gain,options.flipgain,options.rotgain,options.pixsize,options.ftbin,options.fmdose,options.gpu,options.throw,options.kv,options.patch)


(fformat,filelist,framedir,alidir,gain,flipgain,rotgain,pixsize,ftbin,fmdose,gpu,throw,kv,patch) = GetData()

file1 = open(filelist,'r')
for line in file1:
	name,ext1 =os.path.splitext(line.rstrip())
        name,ext2 = os.path.splitext(name.rstrip())
	print name
        if fformat in ['mrc','MRC']:
		cmd='/usr/local/bin/motioncor2 -InMrc ' + framedir + name + ext2 + ext1 + ' -OutMrc ' + alidir + name + '-a.mrc -FtBin ' + str(ftbin) + ' -Bft 500 150 -Iter 7 -Tol 0.500 -Patch ' + patch + ' -Group 1 -MaskSize 1.000 1.000 -PixSize ' + str(pixsize) + ' -Kv ' + str(kv) + ' -FmDose ' + str(fmdose) + ' -Gain ' + str(gain) + ' -FlipGain ' + str(flipgain) + ' -RotGain ' + str(rotgain) + ' -Gpu ' + str(gpu) + ' -Throw ' + str(throw)
	else:
		cmd='/usr/local/bin/motioncor2 -InTiff ' + framedir + name + ext2 + ext1 + ' -OutMrc ' + alidir + name + '-a.mrc -FtBin ' + str(ftbin) + ' -Bft 500 150 -Iter 7 -Tol 0.500 -Patch ' + patch + ' -Group 1 -MaskSize 1.000 1.000 -PixSize ' + str(pixsize) + ' -Kv ' + str(kv) + ' -FmDose ' + str(fmdose) + ' -Gain ' + str(gain) + ' -FlipGain ' + str(flipgain) + ' -RotGain ' + str(rotgain) + ' -Gpu ' + str(gpu) + ' -Throw ' + str(throw)
	os.system(cmd)
       	print cmd
file1.close()

#You have to change the following flags:
# -InMrc  (to a correct path to your frames)
#-OutMrc (to a correct output folder)
#-FtBin (to a correct binning value: target_px_size/original_px_size )
#-PixSize (to the original_px_size)
#-FmDose (to the appropriate dose per frame)
#-Gain (to a correct path to superres gains)

