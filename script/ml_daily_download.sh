#! /bin/bash
#===============================
#
# ml_daily_download
#
#	> ml_daily_download add-A dir 2022-01-09 2022-01-10
#	> ml_daily_download add-A dir 2022-01-09
#	> ml_daily_download add-A dir
#	> ml_daily_download "add-A OR add-B" dir
#	> ASoC/.alsa-devel@alsa-project.org.cmd
#
# 2022/02/03 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
SCRIPT=`readlink -f "$0" | xargs dirname`
. ${SCRIPT}/lib

CFG=.daily_download.lastday
CMD=.daily_download.cmd

URL=`${SCRIPT}/url_encode.py "$1"`
DIR=`daily_outdir $2`
DAY_FROM=`daily_dayfrom ${DIR}/${CFG} $3`
DAY_TO=`daily_dayto $4`

daily_download "$URL" "$DIR" "$DAY_FROM" "$DAY_TO"

# save day_to
echo ${DAY_TO} > ${DIR}/${CFG}

# save command
# we don't need call this script again
if [ ! -f ${DIR}/${CMD} ]; then
	echo "${SCRIPT}/ml_daily_download.sh \"$1\" \"${DIR}\"" > ${DIR}/${CMD}
	chmod +x ${DIR}/${CMD}
fi
