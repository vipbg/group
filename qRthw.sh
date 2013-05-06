#!/bin/bash
#
#PBS -q serial 
#PBS -N R-Rpbs
#
echo "******STARTING****************************"
#
# cd to the directory from which I submitted the
# job.  Otherwise it will execute in my home directory.
#
echo "R batch job id is $PBS_JOBID"
echo "R input file is:" input.R
echo "Working directory of this job is: " /PBS_O_WORKDIR
#
echo "Beginning to run job"
cd /$PBS_O_WORKDIR
/usr/local/bin/R CMD BATCH --no-restore input.R 
#
echo "******DONE********************************"
