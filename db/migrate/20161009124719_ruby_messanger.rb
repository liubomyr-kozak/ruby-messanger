class RubyMessanger < ActiveRecord::Migration
  def self.up
    create_table :tables do |n|
      n.string :content
      n.string :whenDelete
      n.string :timeStamp
      n.string :hashId
    end
  end
end
