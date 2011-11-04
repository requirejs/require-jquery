#!/bin/sh

# Updates the built require-jquery.js file if either jQuery or RequireJS
# is updated. The new version of either file should be placed in this
# directory, then this command should be run.

cat require.js jquery.js > ../jquery-require-sample/webapp/scripts/require-jquery.js
