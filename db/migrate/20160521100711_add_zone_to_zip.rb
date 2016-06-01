class AddZoneToZip < ActiveRecord::Migration
  def change
    add_column :zips, :zone, :string
  end
end
