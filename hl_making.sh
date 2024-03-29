#!/bin/sh -f
# changed for remote computer running a holewatcher program
# wjr 10-13-22

# sample output line 
# 22oct13a_Exposure_Targeting /data/cryoem/cryoemdata/leginon/22oct13a/rawdata/22oct13a_p3b9g2a_00002sq_v01_00002hl.mrc /data/cryoem/cryoemdata/leginon/22oct13a/rawdata
# the output file Leginon looks for is /data/cryoem/cryoemdata/leginon/22oct13a/rawdata/22oct13a_Exposure_Targeting.json

# modify outdir as needed to match that used by holewatcher.py
outdir=/data/cryoem/cryoemdata/arctica_holes

echo $1 $2 $3 > $outdir/$1.txt

# Leginon will look for the output immediately after this script ends, so this script needs a wait function
mrc_path=$3
file=$1
slash='/'
extension='.json'
outfile=$mrc_path$slash$file$extension

until [ -f $outfile ]
do
     sleep 0.1
     echo waiting for $outfile
done
echo Got it
