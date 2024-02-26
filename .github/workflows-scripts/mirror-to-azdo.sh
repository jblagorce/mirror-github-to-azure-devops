#!/bin/bash

AZORG=$AZORG
AZPROJECT=$AZPROJECT
AZREPOSITORY=$AZREPOSITORY
AZUREPAT=$AZUREPAT
AZUSERNAME=$AZUSERNAME

GITHUBBRANCH=$GITHUBBRANCH
GITHUBREPOSITORY=$GITHUBREPOSITORY
GITHUBPAT=$GITHUBPAT
GITHUBUSERNAME=$GITHUBUSERNAME

git clone "https://$GITHUBUSERNAME:$GITHUBPAT@github.com/$GITHUBREPOSITORY" githubsource

if [ "$?" -ne "0" ]; then
  echo "Failed to clone the github repository. Exiting."
  exit 1
fi

cd githubsource

git checkout $GITHUBBRANCH

git remote add azuredevops "https://$AZUSERNAME:$AZUREPAT@dev.azure.com/$AZORG/$AZPROJECT/_git/$AZREPOSITORY"

git push --set-upstream azuredevops $GITHUBBRANCH

success="$?"
if [ "$success" -ne "0" ]; then
    echo "Failed to push branch $GITHUBBRANCH on azure devops."
fi

cd ..

rm -rf githubsource

exit $success