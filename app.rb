require 'rubygems'
require 'sinatra'
#require 'pry'
require 'rickshaw'
require "sinatra/activerecord"


Sinatra::Application

class Table<ActiveRecord::Base

end

class ApplicationController < Sinatra::Base

end

set :root, File.dirname(__FILE__)
set :public_folder, Proc.new { File.join(root, "public") }


error ActiveRecord::RecordNotFound do
  redirect '/'
end