#!/bin/env python

#isac_to_list.py
# quickly make a list of particles inclided from a class average file
# wjr 04-22-18

# adapded from sxpipe.py by 
# Author: Toshio Moriya 02/15/2017 (toshio.moriya@mpi-dortmund.mpg.de)
#
# This software is issued under a joint BSD/GNU license. You may use the
# source code in this file under either license. However, note that the
# complete SPHIRE and EMAN2 software packages have some GPL dependencies,
# so you are responsible for compliance with the licenses of these packages
# if you opt to use BSD licensing. The warranty disclaimer below holds
# in either instance.
#
# This complete copyright notice must be included in any revised version of the
# source code. Additional authorship citations may be added, but existing
# author citations must be preserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#
# ========================================================================================
# Imports
# ========================================================================================
# Python Standard Libraries
from __future__ import print_function
import sys
import os
import argparse
from utilities import get_im, write_text_file

# SPHIRE/EMAN2 Libraries
import	global_def
from	global_def 	import *

#=========================================================================================
input_isac_class_avgs_path = sys.argv[1]  # only command line argument is saved class averages file
# Retrieve original particle IDs of member particles listed in ISAC class average stack
n_img_processed = EMUtil.get_image_count(input_isac_class_avgs_path)
isac_substack_particle_id_list = []
for i_img in xrange(n_img_processed):
	isac_substack_particle_id_list += get_im(input_isac_class_avgs_path, i_img).get_attr('members')
isac_substack_particle_id_list.sort()
	
# Save the substack particle id list
isac_substack_particle_id_list_file_path = 'isac_substack_particle_id_list.txt'
write_text_file(isac_substack_particle_id_list, isac_substack_particle_id_list_file_path)

