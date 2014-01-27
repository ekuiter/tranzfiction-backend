class AddPlanetToUser < ActiveRecord::Migration
  def change
    add_column :users, :planet, :string
  end
end
