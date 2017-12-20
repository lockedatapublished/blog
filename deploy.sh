#!/bin/bash
AUTHORNAME="Steph"
AUTHOREMAIL="Steph@itsalocke.com"
GITURL="https://$GITHUB_PAT@github.com/$TRAVIS_REPO_SLUG.git"

git config --global user.name $AUTHORNAME
git config --global user.email $AUTHOREMAIL

cd $TRAVIS_REPO_SLUG
git remote set-url origin $GITURL
git pull
git checkout master

git add public/
git commit -am "[ci skip] Documents produced in clean environment via Travis $TRAVIS_BUILD_NUMBER"
git push -u  --quiet origin master
