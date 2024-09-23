bin/rails generate dockerfile --force --fullstaq --jemalloc --yjit --cache --parallel
docker build -t personal-website-rails-webpack .
