#!/bin/sh

kill -9 $(busybox ps | grep "onlineplayxmf" | grep -v grep | cut -d 'r' -f 1)
kill -9 $(busybox ps | grep "mpg123" | grep -v grep | cut -d 'r' -f 1)

