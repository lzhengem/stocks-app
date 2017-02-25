require 'open-uri'

class StocksController < ApplicationController
    # before_action :get_tickers, only: :index
    
    def index
        @stocks = Stock.order(:price).paginate(page: params[:page], per_page: 100)
        # @stocks = Stock.paginate(page: params[:page])
    end
    
    def get_revenue(ticker)
        url = "http://www.nasdaq.com/symbol/#{ticker}/revenue-eps"
        html = open(url)
        doc = Nokogiri::HTML(html)
        chart_url = doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
        chart_html = open(chart_url)
        chart_doc = Nokogiri::HTML(chart_html)
        body1 = chart_doc.children.css("td.body1") #contains the whole chart, including all the other months
        b = chart_doc.children.css("td.body1 b") #contains only the bolded headers
        years = chart_doc.css("table tr td table tr td.dkbluemid b") #contains all the years that it is comparing
        b_text = b[-2].text #contains 'December (FYE)' we want the info from here to end of body1
        start = 0
        body1.each_with_index {|node, index| start = index if node.text.include?(b_text)}
        puts body1[start..-1] #contains the revenue, eps, and dividends of only the last month and the totals
    end
    
    def test
    end
    private
        
        # def get_tickers
        #     @tickers = {}
        #     # pages are separated by the letters
        #     ('C'..'D').each do |letter|
        
            
        #         url = "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}"
        #         html = open(url)
        #         doc = Nokogiri::HTML(html)
        #         doc.css('h3').map do |link|
        #             ticker = link.content.strip.downcase
        #             ticker_doc = Nokogiri.HTML(open(URI.escape("http://www.nasdaq.com/symbol/#{ticker}")))
        #             price = ticker_doc.css("div#qwidget_lastsale.qwidget-dollar").text.tr('$','').to_f
        #             @tickers[ticker] = {name: ticker.upcase, price: price}
        #         end
        #     end
        # end
        
        
end
