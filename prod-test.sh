bin/rails generate dockerfile --force --fullstaq --jemalloc --yjit --cache --parallel --compose
docker build -t personal-website-rails-webpack .
docker compose up 