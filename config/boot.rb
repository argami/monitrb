Bundler.require

Bundler.require :default, ENV["RACK_ENV"].to_sym

Mongoid.load!("db/mongoid.yml")


Dir["#{File.dirname(__FILE__)}/../lib/*.rb"].each {|f| require(f)}
require File.dirname(__FILE__) + '/../db/db'
require File.dirname(__FILE__) + '/../monit'
