#!/bin/zsh

flutter build web --base-href '/RikikiWeb/'

cp build/web/* ../rikiki-github-page

cd ../rikiki-github-page

git add .

git commit -m "new version!"

git push