# frozen_string_literal: true

require 'bundler/setup'
require_relative 'settings'

Dir["#{__dir__}/initializers/*.rb"].each { |file| require file }

require_relative 'loader'
