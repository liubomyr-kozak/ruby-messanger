class Messanger < ActiveRecord::Migration
  def self.up
    create_table :tables do |n|
      n.string :content
      n.string :whenDelete
    end
  end
end
