require 'rubygems'
require "bundler/setup"

require 'sinatra/base'
require 'sinatra/content_for'
require 'pusher'
require 'config'
require 'digest/md5'

class User < Struct.new(:user_name, :email)
  
  def gravatar_url(size=40)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}.png?s=#{size}"
  end
  
end

class Site < Sinatra::Base
  
  enable  :static, :sessions
  set     :root, File.dirname(__FILE__)
  set     :public, Proc.new { File.join(root, "public") }
  
  configure do
    # configure with your own app http://pusherapp.com
    Pusher.app_id = '2860'
    Pusher.key = 'cd9dd4f9a0f97e3a5bf1'
    Pusher.secret = '7a25be1f704e5be98ac1'
  end
  
  helpers Sinatra::ContentFor
  
  helpers do
    def current_user
      @current_user ||= (session[:user_name] ? User.new(session[:user_name], session[:email]) : nil)
    end
  end
  
  get '/?' do
    redirect '/login' unless current_user
    erb :pusher_chat
  end
  
  get '/login' do
    erb :login
  end
  
  get '/logout' do
    session.delete(:user_name)
    session.delete(:email)
    redirect '/login'
  end
  
  post '/authorize' do
    session[:user_name] = params[:user][:user_name]
    session[:email] = params[:user][:email]
    redirect '/'
  end
  
  post '/messages' do
    message = params[:message]
    message[:user] = current_user.user_name
    Pusher['presence-chat'].trigger('message', message)
  end
  
  post '/pusher/auth' do
    if current_user
      auth = Pusher[params[:channel_name]].authenticate(params[:socket_id],
        # mandatory
        :user_id => current_user.email,
        # optional
        :user_info => {
          :user_name   => current_user.user_name, 
          :gravatar_url => current_user.gravatar_url
        }
      )
      content_type 'application/json'
      Pusher::JSON.generate auth
    else
      halt 403, "Not authorized"
    end
  end
  
end