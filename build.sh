#!/bin/sh

# # docker build -t travistest:latest .
echo "$TRAVIS_BRANCH   $TRAVIS_PULL_REQUEST"

# if [ "$TRAVIS_BRANCH" = "master" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
#    echo "true"
# else
#    echo "false"
# fi


if [ "$TRAVIS_BRANCH" = "master" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then echo "true"; else echo "false"; fi
