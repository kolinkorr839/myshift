#!/bin/bash

PORT=9195

mkdir -p /etc/supervisor/conf.d
printf "[program:shift-ui]
command=bundle exec rails server -b 0.0.0.0 -p $PORT
directory=/opt/code/ui/
autostart=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
redirect_stderr=true

[program:shift-runner]
command=/opt/code/runner/runner
directory=/opt/code/runner/
autostart=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
redirect_stderr=true
" > /etc/supervisor/conf.d/shift.conf

export ENVIRONMENT="development"
export PATH="/usr/local/bin:/usr/local/bundle/bin:$PATH"
export RAILS_ENV="development"
export RAILS_SERVE_STATIC_FILES=1

supervisord -n
exec "$@"
