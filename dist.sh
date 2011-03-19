#!/bin/sh

# Assumes RequireJS is in a sibling directory to this repo. Change this
# if it is in another directory.
REQUIREJS=../requirejs

DISTDIR=dist/jquery-require-sample

# This script preps the jquery-require-sample for distribution.

# Make the dist directory
rm -rf dist
mkdir dist
mkdir dist/jquery-require-sample

# Copy the sample files.
cp -r jquery-require-sample/webapp $DISTDIR/webapp

# Copy over the build system for requirejs and basic require files, used by the build.
mkdir $DISTDIR/requirejs
mkdir $DISTDIR/requirejs/adapt
mkdir $DISTDIR/requirejs/build
cp -r $REQUIREJS/bin $DISTDIR/requirejs/bin
cp -r $REQUIREJS/build/jslib $DISTDIR/requirejs/build/jslib
cp -r $REQUIREJS/build/lib $DISTDIR/requirejs/build/lib
cp $REQUIREJS/build/example.build.js $DISTDIR/requirejs/build/example.build.js
cp $REQUIREJS/build/build.bat $DISTDIR/requirejs/build/build.bat
cp $REQUIREJS/build/build.js $DISTDIR/requirejs/build/build.js
cp $REQUIREJS/build/build.sh $DISTDIR/requirejs/build/build.sh
cp $REQUIREJS/build/buildj.bat $DISTDIR/requirejs/build/buildj.bat
cp $REQUIREJS/build/buildj.sh $DISTDIR/requirejs/build/buildj.sh
cp $REQUIREJS/adapt/node.js $DISTDIR/requirejs/adapt/node.js
cp $REQUIREJS/adapt/rhino.js $DISTDIR/requirejs/adapt/rhino.js

cp $REQUIREJS/require.js $DISTDIR/requirejs
cp $REQUIREJS/LICENSE $DISTDIR/requirejs/LICENSE

# Start the build.
cd $DISTDIR/webapp/scripts
../../requirejs/build/build.sh app.build.js
cd ../../..

# Mac weirdness
find . -name .DS_Store -exec rm {} \;

# Package it.
zip -r jquery-require-sample.zip jquery-require-sample/*
