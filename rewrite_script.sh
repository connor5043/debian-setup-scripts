#!/bin/bash
while read url; do
    if echo "$url" | grep -q "www.reddit.com"; then
        echo "https://old.reddit.com${url#*www.reddit.com}"
    else
        echo "$url"
    fi
done

