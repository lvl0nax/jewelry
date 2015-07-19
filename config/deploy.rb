# -*- encoding : utf-8 -*-
# _your_login_ - Поменять на ваш логин в панели управления
# _your_project_ - Поменять на имя вашего проекта
# _your_server_ - Поменять на имя вашего сервера (Указано на вкладке "FTP и SSH" вашей панели управления)
# set :repository - Установить расположение вашего репозитория
# У вас должна быть настроена авторизация ssh по сертификатам

# require 'rvm/capistrano'
# require 'bundler/capistrano'
# load 'deploy/assets'

# ssh_options[:forward_agent] = true

# Settings
set :application, 'jewelry'
dpath = '/home/hosting_lvl0nax/projects/juwelry'
set :deploy_to, dpath
set :keep_releases, 3
# set :deploy_server,   "neon.locum.ru"
set :user, 'hosting_lvl0nax'
set :login, 'lvl0nax'

# Git
set :scm, :git
set :repo_url, 'git@github.com:lvl0nax/jewelry.git'
set :ssh_options, forward_agent: true
set :branch, 'new_version'

# RVM
set :rvm_type, :user

# set :use_sudo, false

set :rvm_ruby_version,  "2.1.5"
set :rvm_path, '/usr/local/rvm'
set :rvm_custom_path, '/usr/local/rvm'
set :rake,           -> { "rvm use #{rvm_ruby_version} do bundle exec rake" }
set :bundle_cmd,     -> { "rvm use #{rvm_ruby_version} do bundle" }

set :linked_files, %w(
  config/database.yml
  config/secrets.yml
)

set :linked_dirs, %w( public/assets public/uploads public/system )
#
# before 'deploy:finalize_update', 'set_current_release'
# task :set_current_release, :roles => :app do
#   set :current_release, latest_release
# end

# - for unicorn - #
set :unicorn_rails, "/var/lib/gems/1.8/bin/unicorn_rails"
set :unicorn_conf, "/etc/unicorn/juwelry.lvl0nax.rb"
set :unicorn_pid, "/var/run/unicorn/hosting_lvl0nax/juwelry.lvl0nax.pid"
namespace :deploy do
  desc "Start application"
  task :start do
    on roles(:app) do
      run "#{unicorn_rails} -Dc #{unicorn_conf}"
    end
  end

  desc "Stop application"
  task :stop do
    on roles(:app) do
      run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
    end
  end

  desc "Restart Application"
  task :restart do
    on roles(:app) do
      run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_rails} -Dc #{unicorn_conf}"
    end
  end
end
