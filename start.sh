#!/bin/sh
cd $(dirname $0)
RAILS_ENV=production bundle exec puma -p 4000 --pidfile tmp/pids/puma.pid