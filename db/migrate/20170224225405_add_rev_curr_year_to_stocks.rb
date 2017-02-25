class AddRevCurrYearToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :rev_curr_year, :integer
  end
end
