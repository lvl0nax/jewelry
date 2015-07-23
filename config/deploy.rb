# encoding: utf-8
# config valid only for Capistrano 3
lock '3.3.5'

# Project configuration options
# ------------------------------

set :application,    'jewelry'
set :login,          'lvl0nax'
set :user,           'hosting_lvl0nax'

set :deploy_to,      "/home/#{fetch(:user)}/projects/#{fetch(:application)}"
set :unicorn_conf,   "/etc/unicorn/#{fetch(:application)}.#{fetch(:login)}.rb"
set :unicorn_pid,    "/var/run/unicorn/#{fetch(:user)}/" \
                     "#{fetch(:application)}.#{fetch(:login)}.pid"
set :bundle_without, [:development, :test]
set :use_sudo,       false

set :repo_url,       'git@github.com:lvl0nax/jewelry.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :scm, :git
set :format, :pretty
set :pty, true

# Change the verbosity level
set :log_level, :info

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w(bin log tmp/cache vendor/bundle public/system)

# Default value for keep_releases is 5
# set :keep_releases, 5

# You unlikely have to change below this line
# -----------------------------------------------------------------------------

# Configure RVM
set :rvm_ruby_version, '2.1.5'
set :rake,            "rvm use #{fetch(:rvm_ruby_version)} do bundle exec rake"
set :bundle_cmd,      "rvm use #{fetch(:rvm_ruby_version)} do bundle"

set :unicorn_start_cmd,
    "(cd #{fetch(:deploy_to)}/current; rvm use #{fetch(:rvm_ruby_version)} " \
    "do bundle exec unicorn_rails -Dc #{fetch(:unicorn_conf)})"

# - for unicorn - #
namespace :deploy do
  desc 'Start application'
  task :start do
    on roles(:app) do
      execute "#{fetch(:unicorn_start_cmd)}"
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      execute "[ -f #{fetch(:unicorn_pid)} ] && " \
              "kill -QUIT `cat #{fetch(:unicorn_pid)}`"
    end
  end

  after :publishing, :restart

  desc 'Restart Application'
  task :restart do
    on roles(:app) do
      execute "[ -f #{fetch(:unicorn_pid)} ] && " \
              "kill -USR2 `cat #{fetch(:unicorn_pid)}` || " \
              "#{fetch(:unicorn_start_cmd)}"
    end
  end

  # desc 'precompiling assets..............'
  # task :composer_install do
  #   on roles(:web) do
  #     within release_path do
  #       execute "(cd #{fetch(:deploy_to)}/current; #{fetch(:rake)} assets:precompile RAILS_ENV=production"
  #     end
  #   end
  # end
  #
  # after :publishing, 'deploy:composer_install'
end
