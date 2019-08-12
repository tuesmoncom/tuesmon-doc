#!/bin/sh

# Not exiting for the JSON trailing commas check since just a warning, not an error
tests/check_JSON_trailing_commas.sh

make doc || exit 1
#make pdf || exit 1
rm -rf /tmp/tuesmon-doc-dist || exit 1
cp -r dist /tmp/tuesmon-doc-dist || exit 1
git checkout gh-pages || exit 1
git pull || exit 1
git reset --hard || exit 1
rm -rf dist || exit 1
mv /tmp/tuesmon-doc-dist dist || exit 1
git add --all dist || exit 1
git commit -a -m "Update doc" || exit 1
git push || exit 1
git checkout master || exit 1
