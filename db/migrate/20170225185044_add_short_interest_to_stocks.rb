class AddShortInterestToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :short_interest, :float
  end
end
