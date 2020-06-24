#!/bin/bash

# compile static assets
bundle exec rake assets:clobber && bundle exec rake assets:precompile

# remove the server pid
rm -f tmp/pids/server.pid

# start the server
bundle exec rails s -b 0.0.0.0