class Addcolumntozip < ActiveRecord::Migration
  def change
  	add_column :zips, :shopid, :integer
  end
end
