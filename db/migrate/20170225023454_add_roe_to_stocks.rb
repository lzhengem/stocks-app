class AddRoeToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :roe_curr_year, :string
    add_column :stocks, :roe_last_year, :string
    add_column :stocks, :roe_last_2_year, :string
  end
end
