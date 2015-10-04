# encoding: utf-8

lib_path = File.expand_path('../lib', __FILE__)
$LOAD_PATH << lib_path unless $LOAD_PATH.include?(lib_path)
require 'sprockets'
require 'sprockets/livescript'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/stylesheets'
  environment.append_path 'assets/javascripts'
  run environment
end

map '/' do
  use Rack::Static, urls: [''], index: 'index.html'
  run proc {}
end
