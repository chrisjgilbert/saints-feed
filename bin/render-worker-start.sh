
#!/usr/bin/env bash
# exit on error
set -o errexit

export PATH="${PATH}:/opt/render/project/.render/chrome/opt/google/chrome"
bundle exec rake solid_queue:start

