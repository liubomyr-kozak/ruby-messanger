class AddSecurityRoutingLink < ActiveRecord::Migration
  def change
    add_column :tables, :fakeLinkId, :string
  end
end
