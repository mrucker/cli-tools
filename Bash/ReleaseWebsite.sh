#!/bin/bash
src="$1"
dst="$2"
bkt="$3"

daySeconds=$(expr 24 \* 60 \* 60)
cacheControl="no-transform, public, max-age=$daySeconds, s-maxage=$daySeconds"

green () {
    local GREEN='\033[0;32m'
    local NOCOLOR='\033[0m'
    echo -e "${GREEN}${*}${NOCOLOR}"
}

green 'Jekyll build...'
jekyll build -s $src -d $dst

green 'Compress files...'
find $dst \( -iname '*.html' -o -iname '*.css' -o -iname '*.js' \) -exec gzip -9 -nv {} \; -exec mv {}.gz {} \;

green 'Sync css...'
aws s3 sync $dst $bkt --size-only --exclude '*' --include '*.css' --recursive --delete --cache-control "$cacheControl" --conent-type 'text/css' --content-encoding 'gzip' 

green 'Sync js...'
aws s3 sync $dst $bkt --size-only --exclude '*' --include '*.js' --recursive --delete --cache-control "$cacheControl" --conent-type 'application/javascript' --content-encoding 'gzip'

green 'Sync html...'
aws s3 sync $dst $bkt --size-only --exclude '*' --include '*.html' --recursive --delete --cache-control "$cacheControl" --conent-type 'text/html' --content-encoding 'gzip'

green 'Sync images...'
aws s3 sync $dst $bkt --size-only --exclude '*' --include '*.jpg' --include '*.png' --incude '*.ico' --recursive --delete --cache-control "$cacheControl"

green 'Sync all other files...'
aws s3 sync $dst $bkt --size-only --recursive --delete
