class Mydb < ActiveRecord::Migration
  def self.up
  	create_table :tables do |n|
  		n.string :content
  	end
  end
end
