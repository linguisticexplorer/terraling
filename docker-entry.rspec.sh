#!/bin/bash

echo 'export DATABASE_CLEANER_ALLOW_PRODUCTION=true' >> ~/.bashrc 

while true; do foo; sleep 10; done
# RAILS_ENV=production LOCAL_DEV=true bundle exec rspec

# compile static assets
# bundle exec rake assets:clobber && bundle exec rake assets:precompile

# remove the server pid
# rm -f tmp/pids/server.pid

# start the server
# RAILS_ENV=production LOCAL_DEV=true bundle exec rails s -b 0.0.0.0
