require './db.rb'

class Monitrb < Sinatra::Base
  get '/' do
    'Hello Monitrb!'
  end
  
  post '/collector' do
    Server.parse(request.body.read)
  end
end