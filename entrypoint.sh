#!/bin/bash

set -e

FOLDER=$1
GITHUB_USERNAME=$2
REPO_NAME="${3:-name}"
BRANCH_NAME="${4:-main}"
BASE=$(pwd)

git config --global user.email "johno-actions-push-subdirectories@example.org"
git config --global user.name "$GITHUB_USERNAME"

echo "Cloning folders in $FOLDER and pushing to $GITHUB_USERNAME"

# sync to read-only clones
for folder in $FOLDER/*; do
  if [ -d "$folder" ] # only directories
  then
    cd $folder
    foldername=${PWD##*/}
    cd $BASE

    echo "$folder"

    echo "  Name: $REPO_NAME"
    CLONE_DIR="__${REPO_NAME}__clone__"
    echo "  Clone dir: $CLONE_DIR"

    # clone, delete files in the clone, and copy (new) files over
    # this handles file deletions, additions, and changes seamlessly
    git clone --depth 1 https://$API_TOKEN_GITHUB@github.com/$GITHUB_USERNAME/$REPO_NAME.git $CLONE_DIR &> /dev/null
    cd $CLONE_DIR
    [ -d $foldername ] && find ./$foldername | grep -v ".git" | grep -v "^\.*$" | xargs rm -rf
    # delete all files only in that folder if folder exists
    mkdir -p ./$foldername
    cp -r $BASE/$folder/. ./$foldername
    echo "  Copied files to $foldername"
    
  else
    cd $BASE

    echo "$folder"

    echo "  Name: $REPO_NAME"
    CLONE_DIR="__${REPO_NAME}__clone__"
    echo "  Clone dir: $CLONE_DIR"
    echo "  Updating file: $folder"
    
    git clone --depth 1 https://$API_TOKEN_GITHUB@github.com/$GITHUB_USERNAME/$REPO_NAME.git $CLONE_DIR &> /dev/null
    cd $CLONE_DIR
    find . -maxdepth 1 -type f -exec rm -iv {} \;
    cp -r $BASE/$folder .
  fi

  # Commit if there is anything to
  if [ -n "$(git status --porcelain)" ]; then
    echo  "  Committing $REPO_NAME to $GITHUB_REPOSITORY"
    git add .
    git commit --message "Update $REPO_NAME from $GITHUB_REPOSITORY"
    git push origin $BRANCH_NAME
    echo  "  Completed $REPO_NAME"
  else
    echo "  No changes, skipping $BASE/$folder/"
  fi
  
  cd ..
  rm -r $CLONE_DIR
  cd $BASE
done
