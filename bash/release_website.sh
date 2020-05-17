#!/bin/bash
#This has been tested against aws cli 1.7.45 and jekyll 2.5.3

bucket="$1"
maxage="$2"

src="."
dst="./_site"

cacheControl="no-transform, public, max-age=$maxage, s-maxage=$maxage"

green () {
    local GREEN='\033[0;32m'
    local NOCOLOR='\033[0m'
    echo -e "${GREEN}${*}${NOCOLOR}"
}

green 'Jekyll build...'
jekyll build -s "$src" -d "$dst"

green 'Compressing files...'
find "$dst" \( -iname '*.html' -o -iname '*.css' -o -iname '*.js' \) -exec gzip -9 -n "{}" \; -exec mv "{}.gz" "{}" \;

green 'Syncing css...'
aws s3 sync "$dst" "$bucket" --exclude '*' --include '*.css*' --delete --cache-control "$cacheControl" --content-type "text/css" --content-encoding "gzip" --quiet

green 'Syncing js...'
aws s3 sync "$dst" "$bucket" --exclude '*' --include '*.js' --delete --cache-control "$cacheControl" --content-type 'application/javascript' --content-encoding 'gzip' --quiet

green 'Syncing html...'
aws s3 sync "$dst" "$bucket" --exclude '*' --include '*.html' --delete --cache-control 'no-cache' --content-type 'text/html' --content-encoding 'gzip' --quiet

green 'Syncing images...'
aws s3 sync "$dst" "$bucket" --exclude '*' --include '*.jpg' --include '*.png' --include '*.ico' --delete --cache-control "$cacheControl" --quiet

green 'Syncing all other files...'
aws s3 sync "$dst" "$bucket" --exclude '*.css*' --exclude '*.js' --exclude '*.html' --exclude '*.jpg' --exclude '*.png' --exclude '*.ico'  --exact-timestamps --delete --quiet
