#!/bin/sh

set -e

if [ "${MONGO_DATABASE}" = "**None**" ]; then
  echo "You need to set the MONGO_DATABASE environment variable."
  exit 1
fi

if [ "${MONGO_HOST}" = "**None**" ]; then
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
fi

if [ "${MONGO_USERNAME}" = "**None**" ]; then
  echo "You need to set the MONGO_USERNAME environment variable."
  exit 1
fi

if [ "${MONGO_PASSWORD}" = "**None**" ]; then
  echo "You need to set the MONGO_PASSWORD environment variable."
  exit 1
fi


KEEP_DAYS=${BACKUP_KEEP_DAYS}
KEEP_WEEKS=`expr $(((${BACKUP_KEEP_WEEKS} * 7) + 1))`
KEEP_MONTHS=`expr $(((${BACKUP_KEEP_MONTHS} * 31) + 1))`


#Initialize dirs
mkdir -p "${BACKUP_DIR}/daily/" "${BACKUP_DIR}/weekly/" "${BACKUP_DIR}/monthly/"

#Loop all databases
#Initialize filename vers


DFILE="${BACKUP_DIR}/daily/${DB}-`date +%Y%m%d-%H%M%S`.sql.gz"
WFILE="${BACKUP_DIR}/weekly/${DB}-`date +%G%V`.sql.gz"
MFILE="${BACKUP_DIR}/monthly/${DB}-`date +%Y%m`.sql.gz"
#Create dump
echo "Dumping MongoDB $MONGO_DATABASE database to compressed archive"
mongodump --authenticationDatabase ${MONGO_AUTH_DB} -u ${MONGO_USERNAME} -p ${MONGO_PASSWORD} --host ${MONGO_HOST} --db ${MONGO_DATABASE} --archive="${DFILE}" --gzip
#Copy (hardlink) for each entry
ln -vf "${DFILE}" "${WFILE}"
ln -vf "${DFILE}" "${MFILE}"
#Clean old files
echo "Cleaning older than ${KEEP_DAYS} days for ${DB} database from ${POSTGRES_HOST}..."
find "${BACKUP_DIR}/daily" -maxdepth 1 -mtime +${KEEP_DAYS} -name "${DB}-*.sql*" -exec rm -rf '{}' ';'
find "${BACKUP_DIR}/weekly" -maxdepth 1 -mtime +${KEEP_WEEKS} -name "${DB}-*.sql*" -exec rm -rf '{}' ';'
find "${BACKUP_DIR}/monthly" -maxdepth 1 -mtime +${KEEP_MONTHS} -name "${DB}-*.sql*" -exec rm -rf '{}' ';'
echo "Mongo backup created successfully"

# Executing python script for uploading SQL backup to azure blob storage
if [ "${CLOUD_BACKUP}" = "True" ]; then
  if [ "${CLOUD_PROVIDER}" = "Azure" ]; then
    python azblob_async.py ${DFILE}
  elif [ "${CLOUD_PROVIDER}" = "AWS" ]; then
    python aws_async.py ${DFILE}
  fi
fi