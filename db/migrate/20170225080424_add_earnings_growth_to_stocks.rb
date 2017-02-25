class AddEarningsGrowthToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :earnings_growth, :float
  end
end
