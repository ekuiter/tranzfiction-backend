class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :silicon
      t.integer :plastic
      t.integer :graphite
      t.integer :city_id

      t.timestamps
    end
  end
end
