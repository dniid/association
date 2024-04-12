#!/bin/bash

set -e

# Update databases
bin/rails db:migrate
bin/rails db:migrate RAILS_ENV=test

# Run tests
# bundle exec rspec

bin/rails dev:cache

bin/dev