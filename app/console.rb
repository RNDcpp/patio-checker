require 'sinatra'
require 'json'
require_relative 'baysian_filter'
class Console<Sinatra::Base
  $filter = BaysianFilter.new
  set :bind, '0.0.0.0'
  set :port, 1234
  set :environment, :production
  get '/' do
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

