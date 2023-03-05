#!/bin/sh -f
# Local runs
source /usr/local/anaconda3/etc/profile.d/conda.sh
conda activate 
# variable 1 is the outputname without json extension.
# variable 2 is the input mrc path
echo $1
echo $2
mrc_path=$2
python /home/$USER/packages/ptolemy/lowmag_cli.py -f json $2 > $1
conda deactivate
# mv the result to leginon session rawdata directory
mv $1 ${mrc_path%%rawdata/*}rawdata/$1.json
echo ${mrc_path%%rawdata/*}rawdata/$1.json

