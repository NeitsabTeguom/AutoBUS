#/bin/bash
../utils/compile.sh --appName AutoBUS.Manager --output Release --pkg "--pkg gio-2.0 --pkg libsoup-2.4 --pkg posix" --valacOptions "--thread -D LINUX"
