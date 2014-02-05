class AddReadyAtToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :ready_at, :datetime
  end
end
