#!/bin/bash

set -e

echo "$(dc -e "$(date +"%M") 2 + 60 % p") * * * * /home/shepherd/.shepherd/applications/shepherd/shepherd >/proc/1/fd/1 2>/proc/1/fd/2" | crontab -

# We specifically don't exec cron here because it is suid and we don't want PID 1 to be owned by root because then we can't redirect our output
cron -f

