require 'rubygems'
require "bundler/setup"

require 'sinatra/base'
require 'sinatra/content_for'

require 'config'

class Site < Sinatra::Base
  
  enable  :static, :sessions
  set     :root, File.dirname(__FILE__)
  set     :public, Proc.new { File.join(root, "public") }
  
  helpers Sinatra::ContentFor
  
  get '/?' do
    erb :pusher_chat
  end

end