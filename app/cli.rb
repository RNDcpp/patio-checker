require 'sinatra'
require 'active_record'
require 'json'
require './config/config'
require_relative 'bayesian_filter'

#load initalizers
Dir[Config.root_path('./initializers/*.rb')].each {|file| require file }

#load models
Dir[Config.app_root_path('./models/*.rb')].each {|file| require file }

module CLI
  def self.cli
    binding.irb
  end
end