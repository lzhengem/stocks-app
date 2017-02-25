class AddRevLastYearAndRevLast2YearToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :rev_last_year, :integer
    add_column :stocks, :rev_last_2_year, :integer
  end
end
