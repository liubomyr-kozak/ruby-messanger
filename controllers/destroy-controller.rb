class DestroyController < ApplicationController

  class Table<ActiveRecord::Base

  end

  get '/:id/delete' do
    @delid = Table.where(hashId: params[:id]).first
    erb :delete
  end

  delete '/:id' do
    @data2 = Table.where(hashId: params[:id]).first
    @data2.destroy

    redirect '/'
  end
end