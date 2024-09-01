bin/rails generate dockerfile --fullstaq --jemalloc --yjit --compose --cache --parallel
docker build -t personal-website-rails-container-v2 .
docker compose up 