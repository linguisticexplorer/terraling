#!/bin/bash

export RECAPTCHA_SITE_KEY=6LcYxasZAAAAAL25mMYFfzO-DmDEHjqkFVw0d7_5
export RECAPTCHA_SECRET_KEY=6LcYxasZAAAAAM3ZSKVicnCsKx4U5D262UzdAUEP

# compile static assets
bundle exec rake assets:clobber && bundle exec rake assets:precompile

# remove the server pid
rm -f tmp/pids/server.pid

# start the server
RAILS_ENV=production LOCAL_DEV=true bundle exec rails s -b 0.0.0.0
