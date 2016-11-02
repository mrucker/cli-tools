#!/bin/bash
#This has been tested against aws cli 1.7.45 and jekyll 2.5.3

src="$1"
dst="$2"
bkt="$3"
age="$4"

daySeconds=$(expr 24 \* 60 \* 60)
cacheControl="no-transform, public, max-age=$age, s-maxage=$age"

green () {
    local GREEN='\033[0;32m'
    local NOCOLOR='\033[0m'
    echo -e "${GREEN}${*}${NOCOLOR}"
}

green 'Jekyll build...'
jekyll build -s "$src" -d "$dst"

green 'Compress files...'
find "$dst" \( -iname '*.html' -o -iname '*.css' -o -iname '*.js' \) -exec gzip -9 -nv "{}" \; -exec mv "{}.gz" "{}" \;

green 'Sync css...'
aws s3 sync "$dst" "$bkt" --size-only --exclude "*" --include "*.css" --delete --cache-control "$cacheControl" --content-type "text/css" --content-encoding "gzip" 

green 'Sync js...'
aws s3 sync "$dst" "$bkt" --size-only --exclude '*' --include '*.js' --delete --cache-control "$cacheControl" --content-type 'application/javascript' --content-encoding 'gzip'

green 'Sync html...'
aws s3 sync "$dst" "$bkt" --size-only --exclude '*' --include '*.html' --delete --cache-control "$cacheControl" --content-type 'text/html' --content-encoding 'gzip'

green 'Sync images...'
aws s3 sync "$dst" "$bkt" --size-only --exclude '*' --include '*.jpg' --include '*.png' --include '*.ico' --delete --cache-control "$cacheControl"


green 'Sync all other files...'
aws s3 sync "$dst" "$bkt" --size-only --delete
