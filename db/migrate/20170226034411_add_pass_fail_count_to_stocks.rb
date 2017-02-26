class AddPassFailCountToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :pass_count, :integer
    add_column :stocks, :fail_count, :integer
  end
end
