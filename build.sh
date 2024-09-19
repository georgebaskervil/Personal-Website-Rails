docker compose down
bin/rails generate dockerfile --force --fullstaq --jemalloc --yjit --compose --cache --parallel
docker build -t personal-website-rails-webpack .
docker compose up 