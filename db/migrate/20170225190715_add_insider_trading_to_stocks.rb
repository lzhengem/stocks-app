class AddInsiderTradingToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :insider_trading, :integer, limit: 8
  end
end
