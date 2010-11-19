require 'rubygems'
require "bundler/setup"

require 'sinatra/base'
require 'sinatra/content_for'
require 'pusher'
require 'config'

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
  
  get '/?' do
    erb :pusher_chat
  end
  
  post '/messages' do
    Pusher['chat'].trigger('message', params[:message])
  end

end