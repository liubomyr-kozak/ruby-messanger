require 'rubygems'
require 'sinatra'
#require 'pry'
require 'rickshaw'
require "sinatra/activerecord"

class Table<ActiveRecord::Base

end

set :root, File.dirname(__FILE__)
set :public_folder, Proc.new { File.join(root, "public") }


get '/' do
  allDirty = Table.all

  @all = []

  allDirty.each do |item|
    el = destroyRecords(item)
    if el
      @all.push(item)
    end
  end
  # pry
  erb :indexPage
end


post '/create' do
  @data = Table.new
  @data.content = params[:message]
  @data.whenDelete = params[:whenDelete]
  @data.timeStamp = DateTime.now.to_time.to_i
  @data.save

  @data.hashId = @data.id.to_s.to_sha1
  @data.save

  redirect '/'
end


get '/create' do
  erb :create
end

def destroyRecords(recordItem)
  if recordItem.whenDelete == 'deleteInHour'

    messageTimeStamp = recordItem.timeStamp.to_i
    currentTimeStamp = DateTime.now.to_time.to_i
    timeStampDiffer = currentTimeStamp - messageTimeStamp

    timeDiffer = (timeStampDiffer / 60 / 60).floor >= 1

    if timeDiffer
      recordItem.destroy
      return nil
    end
  end

  return recordItem
end


before '/message/:id' do
  begin
    @showItems = Table.where(hashId: params[:id])
    puts @showItems
    puts @showItems.count
    if @showItems.count > 0
      @showItem = destroyRecords(@showItems.first)
    else
      @showItem = nil
    end
  rescue ActiveRecord::RecordNotFound
    @showItem = nil
  end
end

get '/message/:id' do
  if @showItem
    erb :show
  else
    erb :messageIsDelete
  end

end

after '/message/:id' do
  if @showItem
    if @showItem.whenDelete == 'deleteAfterFirstVisited'
      @showItem.destroy
    end
  end
end

get '/edit/:id' do
  @getid = Table.where(hashId: params[:id]).first
  erb :edit
end

put '/:id' do
  @data1 = Table.where(hashId: params[:id]).first
  @data1.content = params[:message]
  @data1.whenDelete = params[:whenDelete]
  @data1.save

  redirect '/'
end

get '/:id/delete' do
  @delid = Table.find(params[:id])
  erb :delete
end

delete '/:id' do
  @data2 = Table.find(params[:id])
  @data2.destroy

  redirect '/'
end


error ActiveRecord::RecordNotFound do
  redirect '/'
end