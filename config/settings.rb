# frozen_string_literal: true

require 'dry/configurable'
require 'pathname'
require 'dotenv'

Dotenv.load('.env')

class Settings
  extend Dry::Configurable

  setting :root, default: "#{__dir__}/..", constructor: ->(path) { Pathname(path).expand_path }, reader: true
  setting :env, default: ENV.fetch('RACK_ENV', 'development'), reader: true
  setting :database_url, default: "sqlite://db/#{env}.sqlite3", reader: true
  setting :secret_key, default: ENV.fetch('SECRET_KEY'), reader: true
end
