require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Deploys to target environment"
task :deploy do
    sh 'git', 'push', 'heroku', 'master'
end

