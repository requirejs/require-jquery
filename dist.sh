#!/bin/sh

DISTDIR=dist/jquery-require-sample

# This script preps the jquery-require-sample for distribution.

# Make the dist directory
rm -rf dist
mkdir dist

# Copy the sample files.
cp -r jquery-require-sample $DISTDIR

# Start the build.
cd $DISTDIR/webapp/scripts
node ../../r.js -o app.build.js
cd ../../..

# Mac weirdness
find . -name .DS_Store -exec rm {} \;

# Package it.
zip -r jquery-require-sample.zip jquery-require-sample/*
