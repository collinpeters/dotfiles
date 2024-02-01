#!/bin/bash
# execute background rotation script and track log

# dir of script
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}"   )" && pwd   )

source ${DIR}/bg-config.sh

cd `dirname "$0"`

touch $LOG_FILE

while true; do
  # load current picture (in case of restart)
  feh --bg-scale /usr/share/backgrounds/current-background.jpg

  # let it stay for awhile
  sleep 1h

  # rotate in next one
  RESULT=$(./bg-rotor.sh $PICTURES_FOLDER $SEEN_FOLDER)
  echo ${RESULT} >> ${LOG_FILE}

  # keep the log at 100 lines
  tail -n 100 ${LOG_FILE} | sponge ${LOG_FILE}
done
