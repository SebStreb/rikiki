#!/bin/zsh

rm -rf ./docs

flutter build web --base-href '/rikiki/'

mkdir ./docs

cp -R ./build/web/* ./docs

git add ./docs

git commit -m "new web version!"

git push