#!/bin/bash -e

VERSION=$1

PODSPEC_FILENAME="PTTimer.podspec"
if [ -z $VERSION ]; then
  echo "new version should be supplied at the first argument"
  current=$(egrep "\.version\s+=" ${PODSPEC_FILENAME} | awk -F= '{print $2}')
  echo "(current version is $current)"
  exit 1
fi

sed -E -i '' "s/(.*\.version[[:space:]]*=[[:space:]]*).*/\1\"${VERSION}\"/g" ${PODSPEC_FILENAME}

echo "Updating ExampleTimer Podfile"
(cd ExampleTimer && pod install && git add Podfile* && git commit -m "Update ExampleTimer to pod ${VERSION}")

echo "Committing and pushing version ${VERSION}"
git add ${PODSPEC_FILENAME}
git commit -m "Update podspec to ${VERSION}"
git tag -a $VERSION -m "Update podspec to ${VERSION}"
git push && git push origin $VERSION

echo "Linting podspec"
pod spec lint ${PODSPEC_FILENAME}
echo "Pushing to Cocoapods trunk"
pod trunk push
