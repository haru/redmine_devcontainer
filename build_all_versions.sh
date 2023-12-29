#!/bin/sh
set -e
cd `dirname $0`

SCRIPT="/tmp/build_all$$.sh"

echo "set -ex" > $SCRIPT
echo cd `pwd` >> $SCRIPT

grep -v '^\s*#' supported_versions.conf |grep -v '^\s*$' | xargs -r -I arg echo sh -x build.sh arg >> $SCRIPT

sh -x $SCRIPT

rm $SCRIPT