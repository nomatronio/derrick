require 'sinatra'

configure do
  set :bind, '0.0.0.0'
  set :port, Integer(ENV.fetch('PORT', 3000))
end

get '/' do
  'Welcome to Derrick!'
end
