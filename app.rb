require 'sinatra'
require_relative 'config/application'
require 'pry'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"
  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."
  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all.order(:event_name)
  erb :'meetups/index'
end

get '/meetups/new' do
  if current_user.nil?
    flash[:notice] = "You must be signed in to create an event."
    redirect '/'
  end
  erb :'meetups/new'
end

post '/meetups/new' do
  @meetup = Meetup.new({
    event_name: params[:event_name],
    location: params[:location],
    description: params[:description],
    user_id: current_user.uid})

  if @meetup.valid?
    @meetup.save
    flash[:notice] = "Meetup event created successfully."
    redirect "/meetups/#{@meetup.id}"
  end
end

get '/meetups/:id' do
  erb :'meetups/show'
end

post '/meetups/:id' do
  if session[:user_id].nil?
    flash[:notice] = "You must be signed in to join the event."
    redirect "/meetups/#{params[:id]}"
  end

  @add_attendee = Event.new({user_id: session[:user_id], meetup_id: params[:id]})
  if @add_attendee.valid?
    @add_attendee.save
    flash[:notice] = "Successfully added to event!"
    redirect "/meetups/#{params[:id]}"
  end
  erb :'meetups/show'
end
