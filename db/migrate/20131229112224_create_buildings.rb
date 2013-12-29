class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.integer :city_id
      t.string :type
      t.integer :level

      t.timestamps
    end
  end
end
