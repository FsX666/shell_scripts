#!/bin/bash

user="__user__"
domain="__your_domainname__"

ssh -D 8123 -f -q -N ${user}@${domain}

chromium-browser --proxy-server=socks5://localhost:8123 &

ssh_pid=$(ps aux | grep -e ${domain} | grep -v grep | tr -s ' ' | cut -d ' ' -f2)

sleep 5

while true; do

  chrome_pid=$(ps aux | grep -e chromium-browser | grep -v grep | tr -s ' ' | cut -d ' ' -f2)

  if [ "$chrome_pid" ]; then

    echo 'Chromium running, pid:' "$chrome_pid" && sleep 5

  else

    echo "killing ssh tunnel, pid:" "$ssh_pid"

    kill "$ssh_pid"

    break

  fi

done
