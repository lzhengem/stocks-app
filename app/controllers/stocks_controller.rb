require 'open-uri'

class StocksController < ApplicationController
    # before_action :get_tickers, only: :index
    
    def index
        @stocks = Stock.order(:price).paginate(page: params[:page], per_page: 100)
        # @stocks = Stock.where("rev_curr_year > 0 and rev_last_year > 0 and rev_last_2_year > 0").order(:price).paginate(page: params[:page], per_page: 100)
    end
        
end
