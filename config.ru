require 'rubygems'
require 'bundler'

Bundler.require

ENV["RACK_ENV"] = 'production'

Mongoid.load!("db/mongoid.yml")
require './db/db.rb'
require './monit.rb'
run Monitrb