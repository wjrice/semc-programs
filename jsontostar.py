#! /usr/bin/env python
# converts EMAN 2.31+ 3D particle picks to star format
# output star files can be read by Warp for subtomo creation
# need to run in the directory where you ran e2projectmanager.py
# use: jsontostar.py [label]  where label is the label used in the EMAN2 picker

# wjr 02-12-2021

from glob import glob
import re
from EMAN2 import *
import argparse

parser = argparse.ArgumentParser(description='convert EMAN2 3d particle picks to star')
parser.add_argument('label',type=str, help='Label used for segmented particles')
args = parser.parse_args()

json_files = glob.glob("info/*_info.json")
for boxlist in json_files:
	m = re.search(r'info\/(.*)_info.json',boxlist)
	outstar = m.groups()[0] + '_eman2.star'
	print "writing %s"%(outstar)
	s=js_open_dict(boxlist)
	keys=s['class_list'].keys()
	for k in keys:
		if s['class_list'][k]['name'] == args.label:
			goodkey = int(k)
	try:
		goodkey
	except NameError:
		print "Label %s not found in %s" %(args.label,boxlist)
	else:
		f=open(outstar,'w')
		f.write('# RELION; version 3.0.4\n\ndata_\nloop_\n_rlnCoordinateX #1\n_rlnCoordinateY #2\n_rlnCoordinateZ #3\n')
		for particle in s['boxes_3d']:
			if particle[5] == goodkey:
				f.write("%i   %i   %i\n" %(particle[0],particle[1],particle[2]))
 		f.close()


