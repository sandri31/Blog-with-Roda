# frozen_string_literal: true

require_relative 'config/boot'

run ->(env) { Router.call(env) }
