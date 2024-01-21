#!/bin/sh
echo -ne '\033c\033]0;Digital Logic Sim 2\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Digital Logic Sim 2.x86_64" "$@"
