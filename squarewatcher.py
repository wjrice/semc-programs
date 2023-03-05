#! /usr/bin/env python

import os
import sys
import json
from os import listdir
from os.path import isfile, join
import time

search_dir = '/data/cryoem/cryoemdata/arctica_squares'   # directory to search for squares
path = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, path)

import numpy as np
import torch

from ptolemy.images import load_mrc, Exposure
import ptolemy.algorithms as algorithms
import ptolemy.models as models
modelpath = path + '/weights/211215_lowmag_64x5_defaultadam_tightw_e2.torchmodel'


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
            (dollar1,dollar2,dollar3) = Line.split()  # variable 1 is the outputname without json extension.  variable 2 is the input mrc path
            os.remove(myfile) #delete it now
            fmt = 'json'
            verbose = False
            output = dollar3   # dollar3 was made by the square makind script
            path = dollar2   #path is the file to read which seems to include full path
            print ("output=%s   path=%s dollar1=%s dollar2=%s \n" %(output,path,dollar1,dollar2,))
            try:
                findsquares(verbose,path, fmt, output)
            except:
                print ("error in findsquares\n")
        time.sleep(0.5)  #seconds
        print ("squarefinder sleeping\n")
        
 

def findsquares(verbose,path,format_,output):
#    args = parser.parse_args()
    #verbose = args.v
    #path = args.path
    #format_ = args.format_
    #output_path = args.output

    # put all in a try -- except so an empty file will be created on error. Leginon interprets empty file as no points
    try:
        # open the montage
        image = load_mrc(path)
    #     if len(image.shape) > 2:
    #         print('WARNING: ' + path + ' is an image stack. Only processing the first image.', file=sys.stderr)
    #         image = image[0]
        ex = Exposure(image)
    
        segmenter = algorithms.PMM_Segmenter()
        ex.make_mask(segmenter)
    
        processor = algorithms.LowMag_Process_Mask()
        ex.process_mask(processor)
    
        cropper = algorithms.LowMag_Process_Crops()
        ex.get_crops(cropper)
        model = models.LowMag_64x5_2ep()
        model.load_state_dict(torch.load(modelpath))
        wrapper = models.Wrapper(model)
        ex.score_crops(wrapper, final=False)
    
        vertices = [box.as_matrix_y().tolist() for box in ex.crops.boxes]
        areas = [box.area() for box in ex.crops.boxes]
        centers = np.round(ex.crops.center_coords.as_matrix_y()).astype(int).tolist()
        intensities = ex.mean_intensities
        scores = ex.crops.scores
    
        if format_ == 'json':
            order = np.argsort(scores)[::-1]
            js = []
            for i in order:
                d = {}
                d['vertices'] = vertices[i]
                d['center'] = centers[i]
                d['area'] = float(areas[i])
                d['brightness'] = float(intensities[i])
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
        print ("Exception!\n")
        if output is not None:
            f = open(output, 'w')
        f.close()


if __name__ == '__main__':
    main()

