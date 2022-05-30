#/bin/bash
if [ ! -d "./static/adminlte/" ] 
then
	version="3.2.0"
	zipFile="v${version}.zip"
	staticPath="./static/"
	adminltePath="${staticPath}adminlte/"
	adminlteZipPath="${staticPath}AdminLTE-${version}/"
	mkdir -p $staticPath
	wget https://github.com/ColorlibHQ/AdminLTE/archive/refs/tags/$zipFile
	unzip $zipFile -d $staticPath
	mv $adminlteZipPath $adminltePath
	rm -f $zipFile
fi
