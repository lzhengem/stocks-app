require 'open-uri'

class StocksController < ApplicationController
    # before_action :get_tickers, only: :index
    
    def index
        # @stocks = Stock.order(:price).paginate(page: params[:page], per_page: 100)#all stocks
        
        #only the ones with no nils
        # @stocks = Stock.where("rev_score != ? and eps_score!= ? and roe_score != ? and analyst_rec_score != ? and 
        #                         surprises_score != ? and earnings_growth_score != ? and short_interest_score !=? and insider_trading_score != ?",
        #                         "N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A").order("pass_count DESC, price ASC").paginate(page: params[:page], per_page: 100)
        
        @stocks =  Stock.order("pass_count DESC, price ASC").paginate(page: params[:page], per_page: 100) #sort by how many passes they have
    end
        
end
