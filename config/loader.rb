# frozen_string_literal: true

require 'zeitwerk'
require 'listen'

loader = Zeitwerk::Loader.new
loader.push_dir Settings.root.join('app')
loader.collapse Settings.root.join('app/*')
loader.enable_reloading
loader.setup
loader.eager_load if ENV['CI']

listener = Listen.to(Settings.root.join('app')) { loader.reload }
listener.start
