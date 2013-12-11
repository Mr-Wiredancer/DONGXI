#!/bin/sh

# set gem source to https://rubygems.org/
sed -i '/source/d' Gemfile
sed -i '1 i source "https://rubygems.org/"' Gemfile

# set database.yml
cp config/database.example.yml config/database.yml
