class Monitrb < Sinatra::Base
	use Rack::Auth::Basic, "Restricted Area" do |username, password|
	  [username, password] == ['monit', 'monit']
	end

  get '/' do
    'Hello Monitrb!'
  end
  
  get '/collector' do
    
  end

  post '/collector' do
    Server.parse(request.body.read)
  end
end