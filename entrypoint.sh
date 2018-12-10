#!/bin/bash

echo "$(dc -e "$(date +"%M") 2 + 60 % p") * * * * * /home/shepherd/.shepherd/applications/shepherd/shepherd" | crontab -

cron

exec tail -f /home/shepherd/.shepherd/log/shepherd.log

