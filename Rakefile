# frozen_string_literal: true

require 'bundler/setup'
require_relative 'config/settings'
require 'sequel_tools'
require 'sequel/core'

db = Sequel.connect(Settings.database_url, test: false, keep_reference: false)

base_config = SequelTools.base_config(
  project_root: Settings.root,
  dbadapter: db.opts[:adapter],
  dbname: db.opts[:database],
  username: db.opts[:username].to_s,
  password: db.opts[:password].to_s
)

namespace :db do
  SequelTools.inject_rake_tasks base_config.merge(log_level: :info, sql_log_level: :info), self
end

task :console do
  require_relative 'config/boot'
  require 'irb'
  ARGV.clear
  IRB.start
end
