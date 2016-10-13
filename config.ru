require './app'
require './helpers/application-helpers.rb'
require './controllers/index-controller'
require './controllers/create-controller'
require './controllers/edit-controller'
require './controllers/destroy-controller'
require './controllers/show-controller'

map('/') { run IndexController }
map('/create') { run CreateController }
map('/edit') { run EditController }
map('/delete') { run DestroyController }
map('/message') { run ShowController }

# run App || ApplicationController