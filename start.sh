#!/bin/sh
cd $(dirname $0)
RAILS_ENV=production bundle exec puma -t 1:4 -w 1 --preload -p 4000 --pidfile tmp/pids/puma.pid --state tmp/puma.state --control-url tcp://127.0.0.1:9293 --control-token foo 2> log/puma-production-4000.error > log/puma-production-4000.log &