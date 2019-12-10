#!/usr/bin/env bash

set -e

release/v2/set-generation-core-projects.sh
git/push-ruby-public-gem-projects.sh
rubygems/publish-gems.sh
