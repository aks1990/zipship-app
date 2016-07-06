class AddBtnBorderColorToZipcontents < ActiveRecord::Migration
  def change
  	add_column :zipcontents, :btn_border_color, :string
  end
end
