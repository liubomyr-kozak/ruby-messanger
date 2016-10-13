class IndexController < ApplicationController

  helpers ApplicationHelpers

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
end