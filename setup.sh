#!/bin/sh
DB_EXIST=`psql -l | grep dongxi_development | wc -l`
RAILS_ROOT=`pwd`

cp -a $RAILS_ROOT/config/application.example.yml $RAILS_ROOT/config/application.yml
cp -a $RAILS_ROOT/config/database.example.yml $RAILS_ROOT/config/database.yml

bundle install

if [ $DB_EXIST == 1 ]; then
  echo "Drop original database"
  rake db:drop
else
  echo "Do nothing yeah."
fi

# setup db
rake db:create && rake db:migrate && rake db:seed


