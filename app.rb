require 'sinatra'
require "sinatra/activerecord"



configure :production do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://ggcennoctzrruk:ueFg4ZVGq-Y9lPQMb0QRlmoSZL@ec2-54-221-255-192.compute-1.amazonaws.com:5432/d72fe54392av9j')

  ActiveRecord::Base.establish_connection(
      :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
  )
end

class Table<ActiveRecord::Base

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