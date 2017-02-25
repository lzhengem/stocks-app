class AddSurprisesToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :surprises_curr_quarter, :float
    add_column :stocks, :surprises_last_quarter, :float
    add_column :stocks, :surprises_last_2_quarter, :float
  end
end
