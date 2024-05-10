
#!/usr/bin/env bash
# exit on error
set -o errexit

bundle exec rake solid_queue:start

