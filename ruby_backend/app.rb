Create a backend app with light web framework (using sinatra)
# It will have a route GET on /. This action will give randomly (in a pool of at least 20) a name of a song from Frank Sinatra.
# Add multiple pages or routes:

#     GET on /. This action will give randomly (in a pool of at least 20) a name of a song from Frank Sinatra.
#     (https://en.wikipedia.org/wiki/List_of_songs_recorded_by_Frank_Sinatra)

#     GET on /birth_date. This action will give Frank Sinatra birth date.

#     GET on /birth_city. This action will give Frank Sinatra birth city.

#     GET on /wives. This action will give all the name of Frank Sinatra wife.


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

