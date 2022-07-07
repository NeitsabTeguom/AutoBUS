#/bin/bash
../utils/compile.sh --appName AutoBUS.Worker --output Release --pkg "--pkg gio-2.0 --pkg libsoup-2.4 --pkg json-glib-1.0" --valacOptions "-D LINUX"
