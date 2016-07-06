class AddHeadingColorToHomes < ActiveRecord::Migration
  def change
  	add_column :homes, :heading_color, :string
  end
end
