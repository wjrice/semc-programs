#!/bin/csh
#PBS -V
### Job name
#PBS -N XXXnameXXX
### Keep Output and Error
#PBS -k eo
### send to right queue
#PBS -q longq
#PBS -l nodes=XXXmpinodesXXX:ppn=24

cd $PBS_O_WORKDIR

mpirun --map-by node -np XXXcoresXXX -hostfile $PBS_NODEFILE XXXcommandXXX

echo "done"
