#! /bin/bash
#===============================
#
# ml_daily_download
#
#	> ml_daily_download alsa-devel@alsa-project.org ASoC 2022-01-09 2022-01-10
#	> ml_daily_download alsa-devel@alsa-project.org ASoC 2022-01-09
#	> ml_daily_download alsa-devel@alsa-project.org ASoC
#	> ASoC/.alsa-devel@alsa-project.org.cmd
#
# 2022/02/03 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
SCRIPT=`readlink -f "$0" | xargs dirname`
. ${SCRIPT}/lib

ML=$1
URL="all/?q=tc%3A"`${SCRIPT}/url_encode.py ${ML}`
DIR=`readlink -f $2`
DAY_FROM=$3
DAY_TO=$4

CFG=.${ML}.lastday
CMD=.${ML}.cmd

[ x = x${DAY_FROM} ] && DAY_FROM=`cat ${DIR}/${CFG}`
[ x = x${DAY_TO} ] && DAY_TO=`date +%Y-%m-%d`

mkdir -p ${DIR}

# This script downloads Linux ML daily
# except ${to}. Otherwise the script will be
# very complex if it calls many times in same day.
DAY=${DAY_FROM}
while [ x${DAY} != x${DAY_TO} ]
do
	PREFIX=`echo ${DAY} | sed -e "s/-//g"`
	download "${URL}+AND+d%3A${DAY}..${DAY}" ${DIR} ${PREFIX}
	DAY=`date '+%Y-%m-%d' --date "1 day ${DAY}"`
done

# save DAY_TO
echo ${DAY_TO} > ${DIR}/${CFG}

# save command
# we don't need call this script again
if [ ! -f ${DIR}/${CMD} ]; then
	echo "${SCRIPT}/ml_daily_download.sh ${ML} ${DIR}" > ${DIR}/${CMD}
	chmod +x ${DIR}/${CMD}
fi
