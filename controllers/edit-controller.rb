class EditController < ApplicationController

  class Table<ActiveRecord::Base

  end


  get '/edit/:id' do
    @getid = Table.where(hashId: params[:id]).first
    erb :edit
  end

  put '/edit/:id' do
    @data1 = Table.where(hashId: params[:id]).first
    @data1.content = params[:message]
    @data1.whenDelete = params[:whenDelete]
    @data1.save

    redirect '/'
  end
end