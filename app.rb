# frozen_string_literal: true

require 'roda'
require_relative 'models'

# The core class of application
class App < Roda
  FILE_INIT_DATA = File.expand_path('data/students.csv', __dir__)

  opts[:root] = __dir__
  plugin :environments
  plugin :render
  plugin :hash_routes

  configure :development do
    plugin :public
    opts[:serve_static] = true
  end

  opts[:students] = StudentList.new
  opts[:students].read_in_csv_data(FILE_INIT_DATA)

  Unreloader.require('routes') {}

  route do |r|
    r.public if opts[:serve_static]

    r.hash_branches

    r.root do
      r.redirect '/schools'
    end
  end
end
