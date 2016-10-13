class CreateController < ApplicationController

  post '/create' do

    if params[:message].to_s.strip.length == 0
      redirect '/'
    end

    @data = Table.new
    @data.content = params[:message]
    @data.whenDelete = params[:whenDelete]
    @data.timeStamp = DateTime.now.to_time.to_i
    @data.passwordIsActive = params[:passwordIsActive]
    @data.password = params[:password]
    @data.save

    @data.hashId = @data.id.to_s.to_sha1
    @data.save

    redirect '/'
  end


  get '/create' do
    erb :create
  end
end