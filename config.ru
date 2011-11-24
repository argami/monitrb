require 'rubygems'
require 'bundler'

ENV["RACK_ENV"] ||= 'development'

require './config/boot.rb'

run Monitrb