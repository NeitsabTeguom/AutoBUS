#/bin/bash

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
cp -r ./Router/bin/Release/* $Router/bin/

echo Build Package : Worker
Worker=$package/Worker
mkdir -p $Worker/bin/
cp -r ./Worker/bin/Release/* $Worker/bin/

echo Build Package : Manager
Manage=$package/Manager
mkdir -p  $Manage/bin/
cp -r ./Manager/bin/Release/* $Manage/bin/

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
cp $mypath/utils/Installer/*.sh $Manage
cp $mypath/utils/Installer/AutoBUS.appname.service $Manage/AutoBUS.Manager.service
sed -i -e 's/appname/Manager/g' $Manage/*.*

# Compress

echo Packaging
rm AutoBUS.zip
cd $package
zip -r $mypath/AutoBUS.zip ./
cd $mypath

# Cleanup
rm -rf $package/
