#/bin/bash
./plugins.sh
../utils/compile.sh --appName AutoBUS.Manager --output Debug --pkg "--pkg gmodule-2.0 --pkg gio-2.0 --pkg libsoup-2.4 --pkg json-glib-1.0 --pkg gee-0.8 --pkg posix" --valacOptions "--debug -D LINUX -D DEBUG"
