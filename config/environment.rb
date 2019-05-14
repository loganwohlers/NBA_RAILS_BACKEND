# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!


require 'bundler'
Bundler.require

require 'open-uri'
require 'rest-client'
require 'json'
require 'net/http'