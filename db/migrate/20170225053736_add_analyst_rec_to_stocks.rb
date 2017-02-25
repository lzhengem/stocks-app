class AddAnalystRecToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :analyst_rec, :string
  end
end
