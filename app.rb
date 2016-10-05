require 'sinatra'
require "sinatra/activerecord"
require './db/config'

class Table<ActiveRecord::Base
  def self.up
    create_table :tables do |n|
      n.string :content
    end
  end
end

get '/' do
  @all = Table.all
  erb :index
end

post '/index' do
  @data = Table.new
  @data.content = params[:message]
  @data.save

  redirect '/display'
end


get '/display' do
  @all = Table.all
  erb :display
end


get '/:id' do
  @getid = Table.find(params[:id])
  erb :edit
end

put '/:id' do
  @data1 = Table.find(params[:id])
  @data1.content = params[:item]
  @data1.save

  redirect '/display'
end

get '/:id/delete' do
  @delid = Table.find(params[:id])
  erb :delete
end

delete '/:id' do
  @data2 = Table.find(params[:id])
  @data2.destroy

  redirect '/display'
end