#!/bin/sh -f
# Local runs
source /usr/local/anaconda3/etc/profile.d/conda.sh
conda activate 
echo $1
echo $2
echo $3
python /home/$USER/packages/ptolemy/medmag_cli.py -f json -o $3/$1.json $2
conda deactivate


