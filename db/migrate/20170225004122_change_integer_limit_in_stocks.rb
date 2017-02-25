class ChangeIntegerLimitInStocks < ActiveRecord::Migration
  def change
    change_column :stocks, :rev_curr_year, :integer, limit: 8
    change_column :stocks, :rev_last_year, :integer, limit: 8
    change_column :stocks, :rev_last_2_year, :integer, limit: 8
  end
end
