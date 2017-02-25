class AddEpsColumnsToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :eps_curr_year, :decimal
    add_column :stocks, :eps_last_year, :decimal
    add_column :stocks, :eps_last_2_year, :decimal
  end
end
