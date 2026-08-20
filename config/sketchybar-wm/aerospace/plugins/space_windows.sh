#!/bin/bash

# Under AeroSpace the per-workspace app strip is built by space_app.sh, which
# already runs once per workspace item and can query its own windows. This file
# exists so the two backends present the same layout; nothing subscribes to it.
exit 0
