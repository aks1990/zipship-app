class AddZipcountToZipcontents < ActiveRecord::Migration
  def change
  	add_column :zipcontents, :zipcount, :integer
  end
end
