#!/bin/sh

echo "/usr/local/bin/intuos4oled.py init --id $1 > /tmp/intuos_init 2>&1" | at now

