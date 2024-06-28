#!/bin/bash

set -e

# Clear old pid file
rm -f tmp/pids/server.pid

# Update databases
(rails db:migrate:status | grep "^\s*down") && rails db:migrate || echo "No pending migrations found."
# bin/rails db:setup
# bin/rails db:setup RAILS_ENV=test

# Run tests
# bundle exec rspec

# Start server
bin/dev
