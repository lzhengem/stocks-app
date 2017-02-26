class AddForecastToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :forecast_year_0, :float
    add_column :stocks, :forecast_year_1, :float
    add_column :stocks, :forecast_year_2, :float
    add_column :stocks, :forecast_year_3, :float
    add_column :stocks, :forecast_score, :string
  end
end
