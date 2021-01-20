#!/bin/sh
cd $(dirname $0)
bundle exec pumactl -P tmp/pids/puma.pid restart