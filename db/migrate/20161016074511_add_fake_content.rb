class AddFakeContent < ActiveRecord::Migration
  def change
    add_column :tables, :fakeContent, :string
  end
end
