#!/bin/sh
cd `dirname $0`

grep -v '^\s*#' supported_versions.conf |grep -v '^\s*$' | xargs -r -I arg echo sh -x build.sh arg | sh -