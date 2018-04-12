#!/bin/bash

# Set the directory where bookmarks are to be backed up
bkpDir='/d/Simit/Work/myWork/bkps/chrome'

# Set the bookmarks directory
userDir=$(echo $USERPROFILE)
bookmarksDir=$userDir"/AppData/Local/Google/Chrome/User Data/Default"

if [ ! -d $bkpDir ]; then
    mkdir $bkpDir
fi

echo "Copying "$bookmarksDir""/Bookmarks" to $bkpDir ...\n"
cp "$bookmarksDir""/Bookmarks" "$bkpDir"
