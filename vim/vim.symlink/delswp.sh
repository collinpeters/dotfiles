#!/bin/bash

swap_files=`find . -name "*.swp"`

for s in $swap_files ; do
	orig_file=`echo $s | perl -pe 's!/\.([^/]*).swp$!/$1!' `
	echo "Editing $orig_file"
	sleep 1
	vim -r $orig_file -c "DiffOrig"
	echo -n "  Ok to delete swap file? [y/n] "
	read resp
	if [ "$resp" == "y" ] ; then
		echo "  Deleting $s"
		rm $s
	fi
done
