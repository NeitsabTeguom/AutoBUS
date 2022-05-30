#/bin/bash
./plugins.sh
../utils/compile.sh --appName AutoBUS.Manager --output Debug --pkg "--pkg gio-2.0 --pkg libsoup-2.4 --pkg gee-0.8 --pkg posix" --valacOptions "--debug -D LINUX -D DEBUG"
