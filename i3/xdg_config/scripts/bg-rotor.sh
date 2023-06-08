#!/bin/bash
# background wallpaper rotation
# Specify source folder, and folder to move to once seen
# When no pictures are left in source, moves all seen pictures back to source and keeps going

# dir of script
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}"   )" && pwd   )

source ${DIR}/bg-config.sh

if [ ! -d "$UNSEEN_FOLDER" ]; then
	echo "Pictures folder '${UNSEEN_FOLDER}' does not exist"
	exit
fi

if [ ! -d "$SEEN_FOLDER" ]; then
	echo "Seen folder '${SEEN_FOLDER}' does not exist. Creating..."
	mkdir -p ${SEEN_FOLDER}
fi

CMD="find ${UNSEEN_FOLDER} -maxdepth 1 -iname *.jpeg -o -iname *.jpg -o -iname *.png | shuf -n 1"

nextPicture() {
	NEXT=$(eval $CMD)

	cp $NEXT /usr/share/backgrounds/current-background.jpg

	feh --bg-scale $NEXT
	mv -f -v ${NEXT} ${SEEN_FOLDER}
	echo ${NEXT}
}

if [ "$(eval $CMD)" ]; then
	# there are pictures
	nextPicture
else
	MSG="${UNSEEN_FOLDER} is Empty. Moving ${SEEN_FOLDER} contents back to ${UNSEEN_FOLDER}"
	echo ${MSG}
	mv ${SEEN_FOLDER}/* ${UNSEEN_FOLDER}
	nextPicture
fi

