# Homepage (Root path)

helpers do

  def encrypt(input)
    Digest::SHA1.hexdigest(input) unless input.blank?
  end

  def check_login
    return true unless @user.password != encrypt(params[:password])
  end

  def signed_in?
    User.exists?(id: session[:user_id])
  end

  def not_voted?
    return true unless Vote.where(user_id: session[:user_id], track_id: @track.id).first
  end

end

get '/' do
  erb :index
end

get '/tracks' do
  @tracks = Track.all
  erb :'tracks/index'
end

get '/tracks/new' do
  return false unless signed_in?
  @track = Track.new
  erb :'tracks/new'
end

post '/tracks' do
  return false unless signed_in?
  @track = User.find(session[:user_id]).tracks.new(
    title:  params[:title],
    author: params[:author],
    url:    params[:url]
    )
  if @track.save
    redirect '/tracks'
  else
    erb :'tracks/new'
  end
end

get '/tracks/upvote/' do
  @track = Track.find(params[:id])
  redirect '/tracks' unless signed_in? && not_voted?
  @track.votes.create(user_id: session[:user_id])
  redirect '/tracks'
end

get '/user' do
  @user = User.new
  erb :'user/index'
end

post '/user/create' do
  @user = User.new(
    name:     params[:name],
    email:    params[:email],
    password: encrypt(params[:password])
    )
  if @user.save
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :'user/index'
  end
end

post '/user/login' do
  @user = User.where(email: params[:email]).first || User.new
  if check_login
    session[:user_id] = @user.id
    redirect '/tracks'
  else
    @login_errors = true
    erb :'user/index'
  end
end

get '/user/logout' do
  session[:user_id] = nil
  redirect '/tracks'
end