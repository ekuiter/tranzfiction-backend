class ChangeFieldsInResources < ActiveRecord::Migration
  def change
    change_column :resources, :silicon, :decimal, precision: 12, scale: 6
    change_column :resources, :plastic, :decimal, precision: 12, scale: 6
    change_column :resources, :graphite, :decimal, precision: 12, scale: 6
  end
end
