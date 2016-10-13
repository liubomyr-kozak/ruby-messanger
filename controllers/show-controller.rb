class ShowController < ApplicationController
  helpers ApplicationHelpers

  class Table<ActiveRecord::Base

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
end