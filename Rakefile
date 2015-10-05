# encoding: utf-8

lib_path = File.expand_path('../lib', __FILE__)
$LOAD_PATH << lib_path unless $LOAD_PATH.include?(lib_path)
require 'slim'
require 'sprockets'
require 'rake/sprocketstask'
require 'sprockets/livescript'

Rake::SprocketsTask.new do |t|
  environment = Sprockets::Environment.new
  environment.append_path 'assets/stylesheets'
  environment.append_path 'assets/javascripts'
  t.environment = environment
  t.output = 'public/assets'
  t.assets = %w(main.js main.css)
end

task :index do
  File.open('index.html', 'w') do |f|
    f.write Slim::Template.new('index.slim').render(Object.new)
  end
end

task :public_index do
  File.open('public/index.html', 'w') do |f|
    f.write Slim::Template.new('index.slim').render(Object.new)
  end
end

task build: [:index, :assets]
