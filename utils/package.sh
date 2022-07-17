#/bin/bash

unameOut=$(uname -a)
case "${unameOut}" in
	*Microsoft*)	OSType="WSL";; #must be first since Windows subsystem for linux will have Linux in the name too
	*microsoft*)	OSType="WSL2";;
	Linux*)	OSType="LINUX";;
	FreeBSD*)	OSType="UNIX";;
	Darwin*)	OSType="OSX";;
	CYGWIN*)	OSType="WINDOWS";;
	MINGW*)	OSType="WINDOWS";;
	*Msys)	OSType="WINDOWS";;
	*)	OSType="UNKNOWN:${unameOut}"
esac

utilpath=`pwd`

cd ../

projectpath=`pwd`

package=$projectpath/package

Router=$package/Router
Worker=$package/Worker
Manager=$package/Manager

echo Cleaning output
$utilpath/clean.sh

echo Prepare package directory
rm -rf $package/
mkdir $package/


mkdir -p $Router/bin/
mkdir -p $Worker/bin/
mkdir -p $Manager/bin/


# Copy Installer

echo Copy Installer : Router
cp $utilpath/Installer/*.sh $Router
cp $utilpath/Installer/AutoBUS.appname.service $Router/AutoBUS.Router.service
sed -i -e 's/appname/Router/g' $Router/*.*

echo Copy Installer : Worker
cp $utilpath/Installer/*.sh $Worker
cp $utilpath/Installer/AutoBUS.appname.service $Worker/AutoBUS.Worker.service
sed -i -e 's/appname/Worker/g' $Worker/*.*

echo Copy Installer : Manager
cp $utilpath/Installer/*.sh $Manager
cp $utilpath/Installer/AutoBUS.appname.service $Manager/AutoBUS.Manager.service
sed -i -e 's/appname/Manager/g' $Manager/*.*

# Compile Release

echo Make Release : Router
cd ./Router
./release.sh
cd $projectpath
echo Make Release : Worker
cd ./Worker
./release.sh
cd $projectpath
echo Make Release : Manager
cd ./Manager
./release.sh
cd $projectpath

# Copy Release

echo Build Package : Router
cp ./Router/router.config.json $Router/bin/
cp -r ./Router/bin/Release/* $Router/bin/

echo Build Package : Worker
cp ./Worker/worker.config.json $Worker/bin/
cp -r ./Worker/bin/Release/* $Worker/bin/

echo Build Package : Manager
cp ./Manager/manager.config.json $Manager/bin/
cp -r ./Manager/bin/Release/* $Manager/bin/

# Package publication

echo Packaging
case "${OSType}" in
	LINUX)
		echo Package publication for Linux ...
		# https://fr.wikipedia.org/wiki/Dpkg
		# https://linuxhint.com/how-to-add-a-package-repository-to-debian/
		
		# https://www.debian.org/doc/manuals/distribute-deb/distribute-deb.html
		# https://wiki.debian.org/fr/DebianRepository
		# https://wiki.debian.org/DebianRepository/Setup
		;;
	UNIX)
		echo Package publication for Unix ...
		;;
	WINDOWS)
		echo Package publication for Windows ...
		# Inno setup comming soon...
		cd $projectpath
		rm AutoBUS.zip
		cd $package
		zip -r $projectpath/AutoBUS.zip ./
		cd $projectpath
		;;
esac

# Cleanup
rm -rf $package/
