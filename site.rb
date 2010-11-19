require 'rubygems'
require "bundler/setup"

require 'sinatra/base'
require 'sinatra/content_for'
require 'pusher'
require 'config'

class User < Struct.new(:user_name, :email);end

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
    Pusher['chat'].trigger('message', message)
  end
  
end