class AddEpsColumnsToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :eps_curr_year, :float
    add_column :stocks, :eps_last_year, :float
    add_column :stocks, :eps_last_2_year, :float
  end
end
