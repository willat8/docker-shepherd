#!/bin/bash

echo "$(dc -e "$(date +"%M") 2 + 60 % p") * * * * /tmp/nolog_shepherd.sh" | crontab -

exec cron -f

