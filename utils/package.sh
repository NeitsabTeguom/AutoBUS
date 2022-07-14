#/bin/bash

cd ../

mypath=`pwd`
package=$mypath/package

echo Prepare package directory
rm -rf $package/
mkdir $package/

# Compile Release

echo Make Release : Router
cd ./Router
./release.sh
cd $mypath
echo Make Release : Worker
cd ./Worker
./release.sh
cd $mypath
echo Make Release : Manager
cd ./Manager
./release.sh
cd $mypath

# Copy Release

echo Build Package : Router
Router=$package/Router
mkdir -p $Router/bin/
cp ./Router/router.config.json ./Router/bin/Release/
cp -r ./Router/bin/Release/* $Router/bin/

echo Build Package : Worker
Worker=$package/Worker
mkdir -p $Worker/bin/
cp ./Worker/worker.config.json ./Worker/bin/Release/
cp -r ./Worker/bin/Release/* $Worker/bin/

echo Build Package : Manager
Manager=$package/Manager
mkdir -p  $Manager/bin/
cp ./Manager/manager.config.json ./Manager/bin/Release/
cp -r ./Manager/bin/Release/* $Manager/bin/

# Copy Installer

echo Copy Installer : Router
cp $mypath/utils/Installer/*.sh $Router
cp $mypath/utils/Installer/AutoBUS.appname.service $Router/AutoBUS.Router.service
sed -i -e 's/appname/Router/g' $Router/*.*

echo Copy Installer : Worker
cp $mypath/utils/Installer/*.sh $Worker
cp $mypath/utils/Installer/AutoBUS.appname.service $Worker/AutoBUS.Worker.service
sed -i -e 's/appname/Worker/g' $Worker/*.*

echo Copy Installer : Manager
cp $mypath/utils/Installer/*.sh $Manager
cp $mypath/utils/Installer/AutoBUS.appname.service $Manager/AutoBUS.Manager.service
sed -i -e 's/appname/Manager/g' $Manager/*.*

# Compress

echo Packaging
rm AutoBUS.zip
cd $package
zip -r $mypath/AutoBUS.zip ./
cd $mypath

# Cleanup
rm -rf $package/
