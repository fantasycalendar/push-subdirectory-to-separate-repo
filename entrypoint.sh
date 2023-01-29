#!/bin/bash

set -e

FOLDER=$1
DESTINATION_REPOSITORY=$2
BRANCH_NAME=${3:-master}
BASE=$(pwd)

git config --global user.email "fantasycalendar@example.org"
git config --global user.name "Subdirectory_Pusher"

echo "Syncing $FOLDER to $DESTINATION_REPOSITORY"

mkdir sync_destination_folder

CLONE_DIR="__${DESTINATION_REPOSITORY}__clone__"
echo "Cloning into dir: $CLONE_DIR"

# clone, delete files in the clone, and copy (new) files over
# this handles file deletions, additions, and changes seamlessly
git clone --depth 1 https://$API_TOKEN_GITHUB@github.com/$DESTINATION_REPOSITORY.git $CLONE_DIR &> /dev/null

[ -d $FOLDER ] || exit 1;

find ./$CLONE_DIR | grep -v ".git" | xargs rm -rf
# delete all files only in that folder if folder exists

cp -r $BASE/$FOLDER/* ./$CLONE_DIR/
echo "Copied files to $CLONE_DIR"

cd $CLONE_DIR;

# Commit if there is anything to
if [ -n "$(git status --porcelain)" ]; then
  echo  "Committing $FOLDER to $DESTINATION_REPOSITORY"
  git add .
  git commit --message "Update $FOLDER from $DESTINATION_REPOSITORY"
  git push origin $BRANCH_NAME
else
  echo "No changes, not committing."
fi
