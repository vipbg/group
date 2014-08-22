# !/bin/bash
# 
#  qZip: Compress a file or directory via pbs cluster
#  Created by Aaron Wolen on 2013-05-13
# 

input=$1

if [ -z "$1" ]; then 
  echo "You must specify a file or directory to compress."
  exit 1;
fi

qsub="/opt/pbs/default/bin/qsub"
qsub_args="-k n -c c=1 -j oe -S /bin/bash"
name="zip-"$(basename $input | cut -c 1-6)

if [ -f "$input" ]; then
  echo "qZip is compressing file: $input"
  zip_cmd="gzip -c $PWD/$input > $PWD/$input.gz"
elif [ -d "$input" ]; then
  echo "qZip is compressing directory: $input"
  zip_cmd="tar -C $PWD -zcf $PWD/$input.tar.gz $input"
else
  echo "I couldn't find $input. Sure you're in the right place?"
  exit 1
fi

# Submit
echo $zip_cmd | $qsub $qsub_args -N "$name"

sleep 2
rm -f $name.o*
