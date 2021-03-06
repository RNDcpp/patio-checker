require 'sinatra'
require 'rack/contrib'
require 'active_record'
require 'json'
require './config/config'
require_relative 'bayesian_filter'

#load initalizers
initializers_dir = File.expand_path('./initializers/*', __FILE__)
Dir.glob(initializers_dir).each do |initializer|
  require File.basename(initializer)
end

class Console<Sinatra::Base

  use Rack::PostBodyContentTypeParser

  $filter = BayesianFilter.new
  set :bind, '0.0.0.0'
  set :port, 1234
  set :environment, ENV['APP_ENV'].to_sym
  get '/' do
    ActiveRecord::Base
    erb :index
  end
  post '/patio/check' do
    @doc = params['doc']
    if (params['doc'])
      @point = ($filter.parse(@doc,'patioglass')*1000).to_i.to_f/10.0
    else
      @point = nil
    end
    {:point => @point}.to_json
  end
end

