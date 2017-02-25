class AddDividendsToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :dividends, :string
  end
end
