# config valid only for current version of Capistrano
lock '3.6.1'

# set :application, 'my_app_name'
# set :repo_url, 'git@example.com:me/my_repo.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
  set :rbenv_ruby,    '2.1.3'
  set :application,   'gironga'
  set :repo_url,      'git@github.com:Hogeo/gironga.git'
  set :branch,        'master'
  set :deploy_to,     '/var/www/gironga'
  set :linked_dirs,   fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
  set :keep_releases, 3
  # set values for slackistrano deployment notifier
  # set :slack_webhook,      'https://hooks.slack.com/services/T02B5F7S3/B0ATNSDB6/ERhof0moz0987uLtiXXXXXX'
  # set :slack_icon_url,     'https://s3-ap-northeast-1.amazonaws.com/gironga/images/tomato3_small.png'
  # set :slack_username,     'gironga'
  # set :slack_msg_starting, "#{ENV['USER'] || ENV['USERNAME']} による #{fetch :branch} ブランチの #{fetch :rails_env, 'production'} 環境へのデプロイが始まります。"
  # set :slack_msg_finished, "#{ENV['USER'] || ENV['USERNAME']} による #{fetch :branch} ブランチの #{fetch :rails_env, 'production'} 環境へのデプロイが成功しました！！"
  # set :slack_msg_failed,   "#{ENV['USER'] || ENV['USERNAME']} による #{fetch :branch} ブランチの #{fetch :rails_env, 'production'} 環境へのデプロイが失敗しました..."
  namespace :deploy do
    desc 'Restart application'
    task :restart do
      invoke 'unicorn:restart'
    end
    desc 'Create database'
    task :db_create do
      on roles(:db) do |host|
        with rails_env: fetch(:rails_env) do
          within current_path do
            execute :bundle, :exec, :rake, 'db:create'
          end
        end
      end
    end
    desc 'Run seed'
    task :seed do
      on roles(:app) do
        with rails_env: fetch(:rails_env) do
          within current_path do
            execute :bundle, :exec, :rake, 'db:seed'
          end
        end
      end
    end
    after :publishing, :restart
    after :restart,    :clear_cache do
      on roles(:web), in: :groups, limit: 3, wait: 10 do; end
    end
    after :finished,   :cleanup
  end

