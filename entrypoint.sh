#!/bin/bash

echo "$(dc -e "$(date +"%M") 2 + 60 % p") * * * * sh -c '/home/shepherd/.shepherd/applications/shepherd/shepherd --nolog > /proc/self/fd/1 2>/proc/self/fd/2'" | crontab -

exec cron -f

