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
echo Make Release : Manage
cd ./Manage
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

echo Build Package : Manage
Manage=$package/Manage
mkdir -p  $Manage/bin/
cp -r ./Manage/bin/Release/* $Manage/bin/

# Copy Installer

echo Copy Installer : Router
cp $mypath/utils/Installer/*.cmd $Router
cp $mypath/utils/Installer/*.sh $Router
cp $mypath/utils/Installer/AutoBUS.appname.service $Router/AutoBUS.Router.service
sed -i -e 's/appname/Router/g' $Router/*.*

echo Copy Installer : Worker
cp $mypath/utils/Installer/*.cmd $Worker
cp $mypath/utils/Installer/*.sh $Worker
cp $mypath/utils/Installer/AutoBUS.appname.service $Worker/AutoBUS.Worker.service
sed -i -e 's/appname/Worker/g' $Worker/*.*

echo Copy Installer : Manage
cp $mypath/utils/Installer/*.cmd $Manage
cp $mypath/utils/Installer/*.sh $Manage
cp $mypath/utils/Installer/AutoBUS.appname.service $Manage/AutoBUS.Manage.service
sed -i -e 's/appname/Manage/g' $Manage/*.*