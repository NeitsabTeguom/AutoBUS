#/bin/bash
../internal/logging/compile.sh --appDirectory Router
../utils/compile.sh --appName AutoBUS.Router --output Release --pkg "--pkg gmodule-2.0 --pkg gio-2.0 --pkg libsoup-2.4 --pkg json-glib-1.0" --valacOptions "-D LINUX"
