#!/bin/bash

echo "bundle install"
bundle install

echo "bundle exec rubocop"
bundle exec rubocop

echo "bundle exec rspec"
bundle exec rspec
