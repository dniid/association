#!/bin/bash

set -e

# Update ruby dependencies
bundle

# Update nodejs dependencies
yarn

# Update databases
bin/rails db:migrate
bin/rails db:migrate RAILS_ENV=test

# Run tests
bin/rspec

bin/dev