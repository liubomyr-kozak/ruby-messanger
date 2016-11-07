require 'rubygems'
require 'sinatra'
#require 'pry'
require 'rickshaw'
require "sinatra/activerecord"
require "aes"

class Table<ActiveRecord::Base
end

set :root, File.dirname(__FILE__)
set :public_folder, Proc.new { File.join(root, "public") }


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

def checkAndAddFakeDate(recordItem, message)
  if recordItem.passwordIsActive == 'on'
    if message.length >= 35
      recordItem.fakeContent = 35.times.map { [*'0'..'9', *'a'..'z'].sample }.join
    else
      recordItem.fakeContent = message.length.times.map { [*'0'..'9', *'a'..'z'].sample }.join
    end
  end
end

def checkAndAddFakeId(recordItem)
  if recordItem.passwordIsActive == 'on'
    recordItem.fakeLinkId = recordItem.hashId.length.times.map { [*'0'..'9', *'a'..'z'].sample }.join
  end
end


def AESMessage(recordItem, decrypt)

  if decrypt
    if recordItem.passwordIsActive == 'on'
      recordItem.content = AES.decrypt(recordItem.content, recordItem.password)
    else
      recordItem.content = AES.decrypt(recordItem.content,' ')
    end

  else
    if recordItem.passwordIsActive == 'on'
      recordItem.content = AES.encrypt(recordItem.content, recordItem.password)
    else
      recordItem.content = AES.encrypt(recordItem.content,' ')
    end
  end

end

# --------------------------------- ROUTING -----------------------------------

get '/' do
  allDirty = Table.all

  @all = []

  allDirty.each do |item|
    el = destroyRecords(item)
    if el

      AESMessage(item, true)
      @all.push(item)
    end
  end

  @length = @all.count
  # pry
  erb :indexPage
end


post '/create' do

  if params[:message].to_s.strip.length == 0
    redirect '/'
  end

  @data = Table.new

  @data.whenDelete = params[:whenDelete]
  @data.timeStamp = DateTime.now.to_time.to_i
  @data.passwordIsActive = params[:passwordIsActive]
  @data.password = params[:password]
  @data.content = params[:message]

  AESMessage(@data, false)
  checkAndAddFakeDate(@data, params[:message])

  @data.save

  @data.hashId = @data.id.to_s.to_sha1
  checkAndAddFakeId(@data)

  @data.save

  redirect '/'
end


get '/create' do
  erb :create
end


get '/check-password/:id' do
  @itemHashId = params[:id]
  erb :checkpass
end

before '/message/:id/?:security?' do
  if  params[:security]
    begin
      @showItems = Table.where(fakeLinkId: params[:id])
      if @showItems.count > 0
        @showItem = destroyRecords(@showItems.first)
      else
        @showItem = nil
      end
    rescue ActiveRecord::RecordNotFound
      @showItem = nil
    end

  else
    begin
      @showItems = Table.where(hashId: params[:id])
      if @showItems.count > 0
        @showItem = destroyRecords(@showItems.first)

        if @showItem.passwordIsActive == 'on'
          hashId = @showItem.hashId
          @showItem = nil
          redirect '/check-password/' + hashId
        end
      else
        @showItem = nil
      end

    rescue ActiveRecord::RecordNotFound
      @showItem = nil
    end
  end
end

get '/message/:id/?:security?' do

  if @showItem

    AESMessage(@showItem, true)

    erb :show
  else
    erb :messageIsDelete
  end

end

after '/message/:id/?:security?' do
  if @showItem
    if @showItem.whenDelete == 'deleteAfterFirstVisited'
      @showItem.destroy
    end
  end
end

get '/edit/:id' do
  @getid = Table.where(hashId: params[:id]).first

  AESMessage(@getid, true)

  erb :edit
end

put '/edit/:id' do
  @data1 = Table.where(hashId: params[:id]).first

  @data1.content = params[:message]
  @data1.whenDelete = params[:whenDelete]

  @data1.passwordIsActive = params[:passwordIsActive]
  @data1.password = params[:password]

  checkAndAddFakeDate(@data1, @data1.content)
  checkAndAddFakeId(@data1)
  AESMessage(@data1, false)

  @data1.save

  redirect '/'
end

get '/:id/delete' do
  @delid = Table.where(hashId: params[:id]).first
  AESMessage(@delid, true)
  erb :delete
end

delete '/:id' do
  @data2 = Table.where(hashId: params[:id]).first
  @data2.destroy

  redirect '/'
end

post '/check-record' do
  @record = Table.where(hashId: params[:idRecordItem]).first
  if @record.password == params[:inputPassword]
    redirect '/message/' + @record.fakeLinkId + '/true'
  else
    redirect '/'
  end
end

error ActiveRecord::RecordNotFound do
  redirect '/'
end