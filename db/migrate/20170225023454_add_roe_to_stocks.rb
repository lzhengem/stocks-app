class AddRoeToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :roe_curr_year, :float
    add_column :stocks, :roe_last_year, :float
    add_column :stocks, :roe_last_2_year, :float
  end
end
