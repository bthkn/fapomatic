#!/bin/sh

# fapomatic.sh
#
# Created by Mikhail Perov on 22.01.2023.

if [ ! $1 ]; then
  echo "Usage: $0 REPO\n\n\r" \
        "\rArgs:\n" \
        "\r\t<REPO>\tgithub repository, format: 'username/repository'"
  exit 1
fi

WRK_DIR=$(pwd)
FAP_REPO="$1"
FAP_REPO_URL="https://github.com/$FAP_REPO"
FAP_REPO_NAME=$(echo $FAP_REPO | awk -F'/' '{print $2}')
FAP_DIR_TEMP="/tmp/$FAP_REPO_NAME"
FAP_DIR="$WRK_DIR/$FAP_REPO_NAME"

echo "=> Download repository"
git clone --recursive "$FAP_REPO_URL.git" "$FAP_DIR_TEMP"

echo "=> Build FAP"
cd "$FAP_DIR_TEMP" && ufbt
FAP_ID=$(\
  cat "application.fam" | \
  awk -F'=' '/appid="([a-zA-Z0-9_]+)"/{print $2}' | \
  awk -F'#' '{print $1}' | \
  tr -d '", ')
cd "$WRK_DIR" && mkdir -p "$FAP_DIR"
cp "$FAP_DIR_TEMP/dist/$FAP_ID.fap" "$FAP_DIR"

echo "=> Clean up"
rm -rf "$FAP_DIR_TEMP"

echo "=> Done"
