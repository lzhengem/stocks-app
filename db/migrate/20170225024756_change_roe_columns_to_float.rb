class ChangeRoeColumnsToFloat < ActiveRecord::Migration
  def up
    change_column :stocks, :roe_curr_year, :float
    change_column :stocks, :roe_last_year, :float
    change_column :stocks, :roe_last_2_year, :float
  end
end
