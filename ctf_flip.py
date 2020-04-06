#!/data/rice/linux_home/Public/EMAN2/extlib/bin/python
# script to flip the phaes of a series of files once ctf params have been determined by sx_ctr.py
# wjr 12 Nov 2016

import global_def
from global_def import *

def main():
	import os
	import sys

	from optparse import OptionParser
	arglist = []
	for arg in sys.argv:
		arglist.append( arg )
	
	progname = os.path.basename(arglist[0])
        usage = progname + """ input_ctf_params 

        input_ctf_params: output file from sx_cter.py, which was run in Multi-micrograph mode
        Note: files to be flipped should be in same directory.
        Outputs: phase-flipped files in hdf format, with identical filenames as input
"""
	parser = OptionParser(usage, version=SPARXVERSION)
	parser.add_option("--input_ctf_params",         type="string",         default="partres.txt",  help="output from sxcter.py")

	(options, args) = parser.parse_args(arglist[1:])
        infile = options.input_ctf_params
        padimg = True  #ctf correction -- pad image
        sign = 1 # ctf correction - sign
        binary = 1  # ctf correction: phaseflip only
	from utilities import generate_ctf
        from filter import filt_ctf
	global_def.BATCH = True
     
        file_content = open(infile)
        ctflist = file_content.readlines()
        img = EMData()
        for line in ctflist:
                data = line.split()
                imgfile=data[17]
                print "Working on file %s\n" %(imgfile)
                (name,ext) = imgfile.split(".")
                outfile = name + '.hdf'  # Assumes input files are NOT hdf format! otherwise will overwrite them
                df = float(data[0])
                cs = float(data[1])
                voltage = float(data[2])
                apix = float(data[3])
                bfactor = float(data[4])
                amp_contrast = float(data[5])
                astig = float(data[6])
                astig_ang = float(data[7])
                ctf = generate_ctf([df,cs,voltage,apix,bfactor,amp_contrast,astig,astig_ang])
                img.read_image(imgfile)
                corr_img = filt_ctf(img,ctf,padimg,sign,binary)
                corr_img.write_image(outfile) 

if __name__ == "__main__":
	main()
