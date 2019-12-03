#!/bin/bash
set -euo pipefail
shopt -s extglob

cd $(realpath $(dirname $0))

dir_url="https://opensource.apple.com/tarballs/mDNSResponder/"

for file in $(curl -SsL $dir_url | sed -nE 's|.*href="(mDNS[^"]+)".*|\1|p'); do
  version="$(echo $file | sed -E 's|mDNSResponder-(.*).tar.gz|\1|')"
  dir="mDNSResponder-$version"

  if ! git tag -l | grep -q "$version"; then
    rm -rf ./!(pull-tars.sh)

    file_url="$dir_url$file"
    wget $file_url
    tar -xf $file
    rm $file
    mv $(find $dir -depth 1) .
    rmdir $dir
    git add .
    git commit -m "update to version $version from $file"
    git tag "$version"
  fi
done



