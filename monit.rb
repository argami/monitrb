class Monitrb < Sinatra::Base

  use Rack::Auth::Basic, "Restricted Area" do |username, password|
	  [username, password] == ['monit', 'monit']
	end

  get '/' do
    @servers = Server.all
    erb :index
  end
  
  # get '/monit/collector' do
  #   "status"
  # end

  post '/monit/collector' do
    Server.parse(request.body.read)
  end


  post '/collector' do
    Server.parse_json(request.body.read, request.ip)
  end



  helpers do
    def stylesheet
      File.read( 'views/style.css' )
      #app.settings.stylesheet ? File.read( app.settings.stylesheet ) : ''
    end

    def time_in_words(seconds)
      case seconds
      when 0..60
        "#{seconds        } seconds"
      when 60..3600
        value = seconds/60
        "#{value} minute#{value > 1 ? 's' : ''}"
      when 3600..86400
        value = seconds/3600
        "#{value} hour#{  value > 1 ? 's' : ''}"
      when 86400..604800
        value = seconds/86400
        "#{value} day#{   value > 1 ? 's' : ''}"
      when 604800..2419200
        value = seconds/604800
        "#{value} week#{  value > 1 ? 's' : ''}"
      when 2419200..31536000
        value = seconds/2419200
        "#{value} month#{  value > 1 ? 's' : ''}"
      when 31536000..3153600000
        value = seconds/31536000
        "#{value} year#{  value > 1 ? 's' : ''}"
      else
        nil
      end
    end
  end
end
