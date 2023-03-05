#! /usr/bin/env python

import os
import sys
import json
from os import listdir
from os.path import isfile, join
import time

search_dir = '/data/cryoem/cryoemdata/arctica_holes'   # directory to search for holes
path = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, path)

import numpy as np
import torch

from ptolemy.images import load_mrc, Exposure
import ptolemy.algorithms as algorithms
import ptolemy.models as models
modelpath_seg = path + '/weights/211026_unet_9x64_ep6.torchmodel'
modelpath_cls = path + '/weights/211214_medmag_128x4_avgpool_e5.torchmodel'

sleeptime = 0.1 #seconds to wait to scan new files


def filesInDirectory(my_dir: str):
    onlyfiles = [f for f in listdir(my_dir) if isfile(join(my_dir, f))]
    return(onlyfiles)

def main():
    while True:
        files = filesInDirectory(search_dir)
        for myfile in files:  # should be only 1 file but just in case...
            if myfile.endswith('sq.mrc.txt'):
                break     # ignore sq images
            myfile = search_dir + '/' + myfile
            f=open(myfile,'r')
            Line = f.readline()
            f.close()
            (dollar1,dollar2,dollar3) = Line.split()
            os.remove(myfile) #delete it now
            fmt = 'json'
            verbose = False
            output = dollar3 + '/' + dollar1 + '.' + fmt  #dollar3 is the file saving path, dollar1 is the file itself, dollar3/dollar1 seems to be same as dollar2 ??
            path = dollar2   #path is the file to read which seems to include full path
            print ("output=%s   path=%s dollar1=%s dollar2=%s dollar3=%s\n" %(output,path,dollar1,dollar2,dollar3))
            try:
                findholes(verbose,path, fmt, output)
            except:
                print ("error in findholes\n")
        time.sleep(sleeptime)  #seconds
        print ("holefinder sleeping\n")
        
 

def findholes(verbose,path,format_,output):

#    import argparse
    #parser = argparse.ArgumentParser()
#
    #parser.add_argument('path', help='directory to match montage images')
    #parser.add_argument('-v', action='store_true')
    #parser.add_argument('-f', '--format', dest='format_', default='json', help='format to write region coordinates')
    #parser.add_argument('-o', '--output', help='output file path')
#
    #args = parser.parse_args()
    #verbose = args.v
    #path = args.path
    #format_ = args.format_
    #output_path = args.output
    
    try:
        # open the montage
        print ("working on %s" %(path))
        image = load_mrc(path)
#     if len(image.shape) > 2:
#         print('WARNING: ' + path + ' is an image stack. Only processing the first image.', file=sys.stderr)
#         image = image[0]
        ex = Exposure(image)
        
        segmenter = algorithms.UNet_Segmenter(64, 9, model_path=modelpath_seg)

        ex.make_mask(segmenter)
        
        processor = algorithms.MedMag_Process_Mask()
        ex.process_mask(processor)
    
        cropper = algorithms.MedMag_Process_Crops()
        ex.get_crops(cropper)
        model = models.AveragePoolModel(4, 128)
        model.load_state_dict(torch.load(modelpath_cls))
        wrapper = models.Wrapper(model)
        ex.score_crops(wrapper, final=False)
    
        vertices = [box.as_matrix_y().tolist() for box in ex.crops.boxes]
        areas = [box.area() for box in ex.crops.boxes]
        centers = np.round(ex.crops.center_coords.as_matrix_y()).astype(int).tolist()
        # intensities = ex.mean_intensities
        scores = ex.crops.scores
    
        if format_ == 'json':
            order = np.argsort(scores)[::-1]
            js = []
            for i in order:
                d = {}
                d['vertices'] = vertices[i]
                d['center'] = centers[i]
                d['area'] = float(areas[i])
                # d['brightness'] = float(intensities[i])
                d['score'] = float(scores[i])
            
                js.append(d)
        
            content = json.dumps(js)

        elif format_ == 'txt': # write coordinates simply as tab delimited file
            # get the regions centers
            points = centers
            # points are (y-axis, x-axis)
            # flip to (x-axis, y-axis)
            # points = np.stack([points[:,1], points[:,0]], axis=1)
    
            content = ['\t'.join(['x_coord', 'y_coord'])]
            for point in points:
                content.append('\t'.join([str(point[0]), str(point[1])]))
            content = '\n'.join(content)

        f = sys.stdout
        if output is not None:
            f = open(output, 'w')
        print(content, file=f)
        f.close()
    except: #create empty file on exception
        if output is not None:
            f = open(output, 'w')
        f.close()


if __name__ == '__main__':
    main()

