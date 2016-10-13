class AddPassFiled < ActiveRecord::Migration
  def change
    add_column :tables, :passwordIsActive, :string
    add_column :tables, :password, :string
  end
end
