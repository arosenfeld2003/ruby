require 'sinatra'

set :bind, '0.0.0.0'
set :port, 8080

def randomNum(max)
  return rand max
end

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "401 Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials.to_a == ['admin', 'admin']
  end
end

def app(infoArray)
  get '/' do
    num = randomNum(23)
    "#{infoArray[1][num]}"
  end
  get '/birth_date' do
    "#{infoArray[2][0]}"
  end
  get '/birth_city' do
    "#{infoArray[3][0]}"
  end
  get '/wives' do
    infoArray[4].join(', ')
  end
  get '/picture' do
    # redirect "https://upload.wikimedia.org/wikipedia/commons/a/af/Frank_Sinatra_%2757.jpg"
    send_file "Frank_Sinatra_'57.jpg", :type => :jpg
  end
  get '/public' do
    "Everybody can see this page"
  end
  
  get '/protected' do
    protected!
    "Welcome, authenticated client"
  end
end

info = File.read("sinatraInfo.csv")
infoArray = info.split("\n").collect { |row| row.split(',') }
app(infoArray)

