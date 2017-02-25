# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'open-uri'
require 'nokogiri'

class String
    def get_full_number
        t = 1000 #multiplier for thousand
        m = 1000000 #multiplier for million
        b = 1000000000 #multiplier for billion
    
        if self.include?('t')
            self.to_i * t 
        elsif self.include?('m')
            self.to_i * m
        elsif self.include?('b')
            self.to_i * b 
        else self.to_i
        end
    end
end

# @tickers = {}
# pages are separated by the letters
('A'..'B').each do |letter|
# ('A'..'Z').each do |letter|
    url = "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}"
    html = open(url)
    doc = Nokogiri::HTML(html)

    doc.css('h3').map do |link|
        ticker = link.content.strip.downcase
        
        #get price info
        ticker_doc = Nokogiri.HTML(open(URI.escape("http://www.nasdaq.com/symbol/#{ticker}")))
        price = ticker_doc.css("div#qwidget_lastsale.qwidget-dollar").text.tr('$','').to_f
        
        #get revenue information
        rev_url = "http://www.nasdaq.com/symbol/#{ticker}/revenue-eps"
        rev_doc = Nokogiri.HTML(open(URI.escape(rev_url)))
        rev_chart_url = rev_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
        rev_chart_doc = Nokogiri.HTML(open(rev_chart_url))
        rev_chart = rev_chart_doc.children.css("td.body1")
        rev_headers = rev_chart_doc.children.css("td.body1 b")
        if rev_headers[-2] #if the chart is avaiable for this symbol

            
            latest_month = rev_headers[-2].text
            start = 0
            rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
            rev_info = rev_chart[start..-1]
            rev_curr_year = rev_info[2].text.scan(/[\w+]/).join.get_full_number
            rev_last_year = rev_info[3].text.scan(/[\w+]/).join.get_full_number
            rev_last_2_year = rev_info[4].text.scan(/[\w+]/).join.get_full_number
            if rev_curr_year.zero?
                latest_month = rev_headers[-3].text
                rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
                rev_info = rev_chart[start..-1]
                rev_curr_year = rev_info[2].text.scan(/[\w+]/).join.get_full_number
                rev_last_year = rev_info[3].text.scan(/[\w+]/).join.get_full_number
                rev_last_2_year = rev_info[4].text.scan(/[\w+]/).join.get_full_number
            end
        else
            rev_curr_year = 0
            rev_last_year = 0
            rev_last_2_year = 0
        end
        
        Stock.create(name: ticker.upcase, 
                            price: price, 
                            rev_curr_year: rev_curr_year,
                            rev_last_year: rev_last_year,
                            rev_last_2_year: rev_last_2_year)
    end
end

# @tickers.each do |key, ticker|
#     Stock.create(name: ticker[:name], 
#                 price: ticker[:price], 
#                 rev_curr_year: ticker[:rev_curr_year])
    
    
# end