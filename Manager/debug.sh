#/bin/bash
../utils/compile.sh --appName AutoBUS.Manager --output Debug --pkg "--pkg gio-2.0 --pkg libsoup-2.4 --pkg posix" --valacOptions "--debug --thread -D LINUX -D DEBUG"
