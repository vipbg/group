# !/bin/bash

# export r script
scriptname=$1

# remove extensions .R
scriptname="${scriptname%%.[R|r]}"
SCRIP=${1:0:12}

echo "R script is" $scriptname

# Construct submission script
sed s/Rpbs/$SCRIP/g < /usr/local/bin/qRthw > qRscripta-$scriptname
sed s/input/$scriptname/g < qRscripta-$scriptname > qRscript-$scriptname

# Submit
/opt/pbs/default/bin/qsub -k n -c c=1 -j oe qRscript-$scriptname

# Clean-up
rm qRscripta-$scriptname
rm qRscript-$scriptname

echo "QR is batching a job for you"; echo "See output in $scriptname.Rout"

sleep 2
rm -f R-$scriptname.o*
