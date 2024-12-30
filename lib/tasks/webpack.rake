# lib/tasks/webpack.rake
namespace :assets do
  task run_webpack: :environment do
    sh "yarn frontend-build"
  end
end

# Enhance the assets:precompile task
Rake::Task["assets:precompile"].enhance [ "assets:run_webpack" ]
