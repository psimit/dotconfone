#!/bin/bash

# Set the directory where bookmarks are to be backed up
bkpDir='/d/Simit/Work/myWork/bkps/chrome'

# Set the bookmarks directory
userDir=$(echo $USERPROFILE)
bookmarksDir=$userDir"/AppData/Local/Google/Chrome/User Data/Default/Bookmarks"

if [ ! -d $bkpDir ]; then
    mkdir $bkpDir
fi

echo "Copying \""$bookmarksDir"\" to \"$bkpDir\" ..."
echo ""
cp "$bookmarksDir" "$bkpDir"
