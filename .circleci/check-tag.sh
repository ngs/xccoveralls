#!/bin/sh

set -eu

V=$(ruby -e 'require "./lib/xccoveralls/version.rb"; puts "v#{Xccoveralls::VERSION}"')
[ $V = $CIRCLE_TAG ] || (
  echo "Xccoveralls::VERSION ${V} does not match with CIRCLE_TAG ${CIRCLE_TAG}"; exit 1
)
