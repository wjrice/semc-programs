#!/bin/sh -f

# changed for computer running a squarewatcher program
# wjr 10-13-22

# modify outdir as needed to match that used by squarewatcher.py
outdir=/data/cryoem/cryoemdata/arctica_squares

# variable 1 is the outputname without json extension.
# variable 2 is the input mrc path

mrc_path=$2
slash='rawdata/'
extension='.json'
file=$1

outfile=${mrc_path%%rawdata/*}$slash$file$extension
echo $1 $2 $outfile > $outdir/$1.txt

until [ -f $outfile ]
do
     sleep 0.1
     echo waiting for $outfile
done


