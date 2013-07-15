# !/bin/bash
# 
#  qExtract: Decompress a file via pbs cluster
#  Created by Aaron Wolen on 2013-05-13
#  Based on http://nparikh.org/notes/zshrc.txt

input=$1

if [ -z "$1" ]; then 
  echo "You must specify a file or directory to extract."
  exit 1;
fi

qsub="/opt/pbs/default/bin/qsub"
qsub_args="-k n -c c=1 -j oe -S /bin/bash"
name="unzip-"$(basename $input | cut -c 1-6)


extract () {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)  echo "tar -jxvf $1"                        ;;
            *.tar.gz)   echo "tar -zxvf $1"                        ;;
            *.bz2)      echo "bunzip2 $1"                          ;;
            *.gz)       echo "gunzip $1"                           ;;
            *.tar)      echo "tar -xvf $1"                         ;;
            *.tbz2)     echo "tar -jxvf $1"                        ;;
            *.tgz)      echo "tar -zxvf $1"                        ;;
            *.zip)      echo "unzip $1"                            ;;
            *.ZIP)      echo "unzip $1"                            ;;
            *.pax)      echo "cat $1 | pax -r"                     ;;
            *)          echo "unknown"                             ;;
        esac
    else
        echo "I couldn't find $1. Sure you're in the right place?"
        exit 1;
    fi
}

extract_cmd=$(extract $input)
extract_cmd=$(echo $extract_cmd | sed "s|$input|$PWD/$input|g")

if [[ $extract_cmd = "unknown" ]]; then
  echo "$input cannot be decompressed because it is an unrecognized file type."
  exit 1;
fi

# Submit
echo "qExtract is decompressing file: $input"
echo $extract_cmd | $qsub $qsub_args -N "$name"

sleep 2
rm -f $name.o*
