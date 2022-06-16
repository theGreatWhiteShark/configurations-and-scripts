#!/bin/bash

export BORG_REPO=/media/black/ncdata_borg_backups

# some helpers and error handling:
log() { printf "\n%s %s\n\n" "$( date )" "$*" 2>> /media/black/ncdata_borg_backups.log; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

## Create a new backup
sudo borg create \
	 --verbose \
	 --filter AME \
	 --list \
	 --stats \
	 --show-rc \
	 --compression lz4 \
	 --exclude-caches \
	 \
	 $BORG_REPO::'ncdata-{now}' \
	 /media/black/ncdata/data 2>> /media/black/ncdata_borg_backups.log

backup_exit=$?

## Maintain only a few (4) backups of all nextcloud data.
##  1. At most 2 days old
##  2. At most 1 week old
##  3. At most 1 month old
##  4. At most 10 months old
sudo borg prune $BORG_REPO \
	 --list \
	 --prefix 'ndata-' \
	 --show-rc \
	 --keep-daily 2 \
	 --keep-weekly 1 \
	 --keep-monthly 1 \
	 --keep-yearly 1 2>> /media/black/ncdata_borg_backups.log

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    log "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    log "Backup and/or Prune finished with warnings"
else
    log "Backup and/or Prune Compact finished with errors"
fi

exit ${global_exit}
