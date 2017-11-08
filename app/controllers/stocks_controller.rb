require 'open-uri'

class StocksController < ApplicationController
    # before_action :get_tickers, only: :index
    
    def index
        # @stocks = Stock.order(:price).paginate(page: params[:page], per_page: 100)#all stocks
        
        #only the ones with no nils
        # @stocks = Stock.where("rev_score != ? and eps_score!= ? and roe_score != ? and analyst_rec_score != ? and 
        #                         surprises_score != ? and earnings_growth_score != ? and short_interest_score !=? and insider_trading_score != ?",
        #                         "N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A").order("pass_count DESC, price ASC").paginate(page: params[:page], per_page: 100)
        
        @stocks =  Stock.order("pass_count DESC, price ASC").paginate(page: params[:page], per_page: 50) #sort by how many passes they have

    end
    
    def create
        if @stock = Stock.find_by(name: params[:name]) || Stock.find_by(name: params[:name].upcase)
            @stock.destroy
        end
        @stock = Stock.new(name: params[:name].downcase)
        @stock.update
        # flash[:success] = "#{@stock.name} has been saved"
        
        redirect_to stocks_path
        #tried to update all of one letter...but takes too long
        # #get all the tickers from letter 'A' into tickers
        # first_doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{params[:letter]}&pagesize=200"
        # if first_doc.css("a#two_column_main_content_lb_LastPage").any?
        #     last_page = first_doc.css("a#two_column_main_content_lb_LastPage").attribute('href').value.scan(/page=(\d+)/)[0][0].to_i
        # else
        #     last_page = 1
        # end
        # tickers = []
        # (1..last_page).each do |page|
        #     doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{params[:letter]}&pagesize=200&page=#{page}"
        #     doc.css('h3').map do |link|
        #         ticker = link.content.strip.upcase
        #         tickers << ticker
        #     end
        # end
        # tickers.each do |ticker|
        #     if stock = Stock.find_by(name: ticker) || Stock.find_by(name: ticker.upcase)
        #         stock.destroy
        #     end
        #     new_stock = Stock.new(name: ticker)
        #     new_stock.update
        # end
    end
    
    def letter
        @stocks =  Stock.where("name like '#{params[:letter]}%'").order(:name).paginate(page: params[:page], per_page: 50) #sort by how many passes they have
    end
    def show
    end
    
    def pennyStocks
         @stocks =  Stock.where("price <= 1").order("pass_count DESC, price ASC").paginate(page: params[:page], per_page: 50)
    end
        
end
