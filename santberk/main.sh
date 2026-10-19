#!/bin/bash
# main.sh - Evergreen (0)b launcher
# runs both .m and .com versions
echo "hexdiff_DBoqm (0)b Evergreen - No Date"
cd "$(dirname "$0")"
octave --quiet --eval "hexdiff_DBoqm()"
echo ""
echo "DOS COM 263b:"
strings hexdiff_DBoqm.com | grep OQM
