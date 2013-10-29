#!/bin/sh
RAILS_ROOT=`pwd`

bundle install

# setup db
rake db:drop && rake db:create && rake db:migrate && rake db:seed


