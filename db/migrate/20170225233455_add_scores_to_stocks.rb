class AddScoresToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :rev_score, :string
    add_column :stocks, :eps_score, :string
    add_column :stocks, :roe_score, :string
    add_column :stocks, :analyst_rec_score, :string
    add_column :stocks, :surprises_score, :string
    add_column :stocks, :earnings_growth_score, :string
    add_column :stocks, :short_interest_score, :string
    add_column :stocks, :insider_trading_score, :string
  end
end
