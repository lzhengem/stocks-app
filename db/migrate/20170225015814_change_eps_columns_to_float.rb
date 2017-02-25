class ChangeEpsColumnsToFloat < ActiveRecord::Migration
  def up
    change_column :stocks, :eps_curr_year, :float
    change_column :stocks, :eps_last_year, :float
    change_column :stocks, :eps_last_2_year, :float
  end
end
