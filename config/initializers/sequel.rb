# frozen_string_literal: true

require 'sequel'
require 'forme'

DB = Sequel.connect(Settings.database_url)

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :forme_set
