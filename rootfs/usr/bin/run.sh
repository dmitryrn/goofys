#!/bin/bash

syslog-ng -f /etc/syslog-ng/syslog-ng.conf

[[ "$UID" -ne "0" ]] && MOUNT_OPTS="-o allow_other"
if [[ -n $CHEAP ]]; then
    cheap_flag="--cheap"
else
    cheap_flag=""
fi

if [[ -n $NO_IMPLICIT_DIR ]]; then
    no_implicit_dir_flag="--no-implicit-dir"
else
    no_implicit_dir_flag=""
fi

goofys -f ${ENDPOINT:+--endpoint $ENDPOINT} --region $REGION --stat-cache-ttl $STAT_CACHE_TTL --type-cache-ttl $TYPE_CACHE_TTL --dir-mode $DIR_MODE --file-mode $FILE_MODE --uid $UID --gid $GID $MOUNT_OPTS "$cheap_flag" "$no_implicit_dir_flag" $BUCKET $MOUNT_DIR
