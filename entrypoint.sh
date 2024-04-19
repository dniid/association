#!/bin/bash

set -e

# Clear old pid file
rm -f tmp/pids/server.pid

# Update databases
bin/rails db:migrate
bin/rails db:migrate RAILS_ENV=test

# Run tests
# bundle exec rspec

# Start server
bin/dev
