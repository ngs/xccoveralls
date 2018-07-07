#!/bin/sh

set -eu

mkdir ~/.gem
echo ":rubygems_api_key: ${RUBYGEMS_API_KEY}" > ~/.gem/credentials
chmod 600 ~/.gem/credentials
