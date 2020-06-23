# set :stages       , %w(testing production travisci)
# set :default_stage, "production"

# require "capistrano/ext/multistage"
require "bundler/capistrano"

# require profile scripts
default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

# if :aws_deploy
set :ssh_options, {
  config: false,
  # auth_methods: [:private_key],
  keys: "tmp/.ssh/travis_rsa"
}
# end

server "ec2-13-59-1-150.us-east-2.compute.amazonaws.com", :app, :web, :primary => true
set :application  , "terraling"
set :user         , "travis"
set :deploy_to    , "/home/#{user}/www/#{application}"
set :deploy_via   , :remote_cache
set :use_sudo     , false
# set :multiyaml_stages, "yamls/deploy.yml"
set :keep_releases, 3

# source control
set :scm          , :git
set :scm_verbose  , true
set :repository   , "git://github.com/linguisticexplorer/terraling.git"
set :branch       , "dev"
set :copy_exclude , ['.git']

# require "capistrano-multiyaml"

require 'capistrano-rbenv'

set :rbenv_type, :user
set :rbenv_ruby_version, '2.6.5'

# role :web, HTTP server (Apache)/etc
# role :app, app server
# role :db, master db server
# server "50.56.97.125:10003", :app, :web, :db, :primary => true

# require "rvm/capistrano"

# set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
# set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs

# before 'deploy:setup', 'rvm:install_rvm'  # install/update RVM
# before 'deploy:setup', 'rvm:install_ruby' # install Ruby and create gemset, OR:
# before 'deploy:setup', 'rvm:create_gemset' # only create gemset

$: << File.join(File.dirname(__FILE__), "..", "lib")

# Bundler
require 'bundler/capistrano'

# Passenger mod_rails:
namespace :deploy do
  task :start do
    # run "bundle install --with development"
    # run "passenger start"
  end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    # Update the gems
    # run "/usr/bin/env bundle install"
    # Update the DB in case (it should not be necessary, but just in case...)
    # Note: Remember to backup before deploying...
    # run "/usr/bin/env bundle exec rake db:migrate"
    # Restart
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :migrate do ; end
end

# Import and download tasks
require 'group_data/capistrano'

# Setup production database.yml
require "capistrano_database_yml"
