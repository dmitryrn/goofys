#!/bin/bash

syslog-ng -f /etc/syslog-ng/syslog-ng.conf

[[ "$UID" -ne "0" ]] && MOUNT_ACCESS="allow_other" || MOUNT_ACCESS="nonempty"
if [[ -n $CHEAP ]]; then
    cheap_flag="--cheap"
else
    cheap_flag=""
fi

goofys -f ${ENDPOINT:+--endpoint $ENDPOINT} --region $REGION --stat-cache-ttl $STAT_CACHE_TTL --type-cache-ttl $TYPE_CACHE_TTL --dir-mode $DIR_MODE --file-mode $FILE_MODE --uid $UID --gid $GID -o $MOUNT_ACCESS "$cheap_flag" $BUCKET $MOUNT_DIR
