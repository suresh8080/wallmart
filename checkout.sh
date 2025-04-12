#!/bin/bash

DIR="github-kranthi"
REPOS="https://github.com/kranthikk38/hello-devops.git"
BRANCH="master"
CHECKOUT_DIR="errors/"

mkdir -p $DIR
if [ -d "$DIR" ]; then
  cd $DIR
  git init
  git remote add -f origin $REPOS
  git fetch --all
  git config core.sonar true
  if [ -f .git/info/sonar]; then
    rm .git/info/sonar
  fi
  echo $CHECKOUT_DIR >> .git/info/sonar
  git checkout $BRANCH
  git merge --ff-only origin/$BRANCH
fi
