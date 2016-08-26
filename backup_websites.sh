#!/bin/bash

#Makes separate backups for each item in /var/www/
#Created to run once a week and keep backups for a specified number of weeks

#Created by Gavin Wade 8/18/2016

DATE=`date +%Y_%d_%m`
BASEDIR=/lib/backups
LOG=$BASEDIR/logs/website_backups.log
WEEKSTOKEEP=3

echo "================ $DATE ==============" >> $LOG
echo "Beginning backup" >> $LOG

for dir in /var/www/*
do
	DIRNAME=`basename $dir`
	DESTDIR=$BASEDIR/websites/$DIRNAME
	FILENAME=$DIRNAME-$DATE.tar.gz
	LOGFILE=$BASEDIR/logs/$DIRNAME-$DATE.log
	tar -czf $DESTDIR/$FILENAME $dir 2>> $LOG
	echo "$FILENAME completed" >> $LOG
	echo "$FILENAME" >> $LOGFILE
	NUMBEROFBACKUPS=`ls -l $DESTDIR | grep $DIRNAME-*.tar.gz | wc -l`
	if [ $NUMBEROFBACKUPS -gt $WEEKSTOKEEP ]
	then
		TODELETE=`head -n 1 $LOGFILE`
		echo "Deleting $TODELETE" >> $LOG
		rm $TODELETE
		tail -n +2 "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"
	fi
done
echo "Backup completed" >> $LOG
echo "==========================================" >> $LOG
