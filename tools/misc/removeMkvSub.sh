#!/bin/sh 

if [ $# -ne 2 ]; then
    echo "usage: removeMkvSub.sh (inputdir) (outputdir)"
fi

INPUTDIR=$1
OUTPUTDIR=$2

ls "$INPUTDIR" | grep .mkv | while read file; do
    echo "mkvmerge --nosubs \"$INPUTDIR/$file\" -o \"$OUTPUTDIR/$file\""
    mkvmerge --nosubs "$INPUTDIR/$file" -o "$OUTPUTDIR/$file"
done
