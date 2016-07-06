class AddBtnBorderToHomes < ActiveRecord::Migration
  def change
  	add_column :homes, :btn_border_color, :string
  end
end
