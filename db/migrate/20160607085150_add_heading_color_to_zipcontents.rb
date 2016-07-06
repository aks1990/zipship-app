class AddHeadingColorToZipcontents < ActiveRecord::Migration
  def change
  	add_column :zipcontents, :heading_color, :string
  end
end
