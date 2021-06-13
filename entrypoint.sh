#! /bin/bash

bundle install

pidfile="tmp/pids/server.pid"
touch $pidfile
rm $pidfile

port=3000
pre_process="$(ps -ef |grep ":$port" |grep -v "grep" |awk '{print $2}')"
kill -9 $pre_process
RAILS_ENV=development
RAILS_ENV=${RAILS_ENV} ./bin/rails assets:precompile
RAILS_ENV=${RAILS_ENV} ./bin/rails s -p $port -b "0.0.0.0" &

./bin/rails db:migrate RAILS_ENV=test

logfile="log/${RAILS_ENV}.log"
touch $logfile # 起動時はないため明示的に作成
tail -f $logfile -n 1