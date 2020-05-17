#!/bin/bash
#This has been tested against aws cli 1.7.45 and jekyll 2.5.3

bucket="$1"
maxage=86400
site="./_site"

[[ -d "$site" ]] || { echo >&2 "not currently in the root of a jekyll project"; exit 1; }

cache="no-transform, public, max-age=$maxage, s-maxage=$maxage"

green () {
    local GREEN='\e[0;32m'
    local NOCOLOR='\e[0m'
    echo -e "${GREEN}$*${NOCOLOR}"
}

compress() {
    # add -v to gzip call for more messages
    find "$site" -iname "$1" -exec gzip -9 -n "{}" \; -exec mv "{}.gz" "{}" \;
}

sync() {
    aws s3 sync "$site" "$bucket" --exclude "*" --include "$1" --cache-control "$2" --content-encoding "$3" --content-type "$4" --delete --quiet
}

green 'Jekyll build...'
jekyll build

green 'Compressing files...'
compress '*.html'
compress '*.css'
compress '*.js'

green 'Syncing css...'
sync '*.css' "$cache" 'gzip' 'text/css'

green 'Syncing js...'
sync '*.js' "$cache" 'gzip' 'application/javascript'

green 'Syncing html...'
sync '*.html' 'no-cache' 'gzip' 'text/html'

green 'Syncing images...'
sync '*.jpg' "$cache" 'identity' 'image/jpeg'
sync '*.png' "$cache" 'identity' 'image/png'
sync '*.ico' "$cache" 'identity' 'image/vnd.microsoft.icon'

#green 'Syncing all other files...'
#aws s3 sync "$dst" "$bucket" --exclude '*.css*' --exclude '*.js' --exclude '*.html' --exclude '*.jpg' --exclude '*.png' --exclude '*.ico'  --exact-timestamps --delete --quiet
