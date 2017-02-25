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
        rev_chart_doc = Nokogiri.HTML(open(URI.escape(rev_chart_url)))
        rev_chart = rev_chart_doc.children.css("td.body1")
        rev_headers = rev_chart_doc.children.css("td.body1 b")
        if rev_headers[-2] #if the chart is avaiable for this symbol get rev info
            latest_month = rev_headers[-2].text
            start = 0
            rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
            rev_info = rev_chart[start..-1] #contains all the relavent information rev_info 0-1 contains headers then 2-4 contains the info revenue from the last 3 years
            #rev_info 5 is latest month eps header, 6-8 contains eps info for last 3 years
            #rev_info 13 contains total headers, rev_info 14 contains total rev header
            #if there is info in the latest month, then we can use totals to calculate rev and eps
            rev_curr_year = rev_info[15].text.scan(/[\w+]/).join.get_full_number
            rev_last_year = rev_info[16].text.scan(/[\w+]/).join.get_full_number
            rev_last_2_year = rev_info[17].text.scan(/[\w+]/).join.get_full_number
            
            #get eps info
            eps_curr_year = rev_info[19].text.to_f
            eps_last_year = rev_info[20].text.to_f
            eps_last_2_year = rev_info[21].text.to_f
            
            #get dividends
            dividends = rev_info[23].text
            
            if rev_curr_year.zero? #if info for the latest month is missing, instead of using totals, use previous month
                latest_month = rev_headers[-3].text
                rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
                rev_info = rev_chart[start..-1]
                rev_curr_year = rev_info[2].text.scan(/[\w+]/).join.get_full_number
                rev_last_year = rev_info[3].text.scan(/[\w+]/).join.get_full_number
                rev_last_2_year = rev_info[4].text.scan(/[\w+]/).join.get_full_number
                
                #get eps info    
                eps_curr_year = rev_info[6].text.to_f
                eps_last_year = rev_info[7].text.to_f
                eps_last_2_year = rev_info[8].text.to_f
                
                #get dividends
                dividends = rev_info[10].text
                
            end
        else
            rev_curr_year = rev_last_year = rev_last_2_year = eps_curr_year = eps_last_year = eps_last_2_year = 0
            dividends = "N/A"
            
        end
        
        # get return on equity ROE
        roe_url = "http://www.nasdaq.com/symbol/#{ticker}/financials?query=ratios"
        roe_doc = Nokogiri.HTML(open(URI.escape(roe_url)))
        if (roe_info = roe_doc.css("div#financials-iframe-wrap td")).any?
            roe_curr_year = roe_info[-4].text.to_f #the roe for the current year is the 4th from last
            roe_last_year = roe_info[-3].text.to_f
            roe_last_2_year = roe_info[-2].text.to_f
        else
            roe_curr_year = roe_last_year = roe_last_2_year = 0
        end
        
        #get analyst recomendations
        rec_url = URI.parse(URI.escape("http://www.nasdaq.com/charts/#{ticker}_rm.jpeg"))
        rec_req = Net::HTTP.new(rec_url.host, rec_url.port) #sometimes this chart is not avaiable, so check to see if its there
        rec_res = rec_req.request_head(rec_url.path)
        if rec_res.code == '200' #if it exists, then parse the image
            image = Magick::ImageList.new  
            urlimage = open(rec_url) # Image Remote URL 
            image.from_blob(urlimage.read)
            buy_x_coordinate = 206 #if the first blue line is at the x coordinate 206, then it is a "buy" recommendation
            analyst_x_coordinate = 0 #find the analyst recomendation x coordinate of the bar
            (0..image.columns).each do |x|
                (0..image.rows).each do |y|
                    pixel = image.pixel_color(x, y)
                    if pixel.blue/256 > 220 and pixel.red/256 <100 and pixel.green/256 <100
                        analyst_x_coordinate = x
                        break 
                    end
                end
                break if analyst_x_coordinate > 0
            end
            if analyst_x_coordinate == 0 #if the bar is not found, then give 'N/A'
                analyst_rec = "N/A"
            elsif analyst_x_coordinate > buy_x_coordinate #if the bar is in the 'Buy' zone, then Buy
                analyst_rec = "Buy"
            else
                analyst_rec = "Sell" #if the bar is not in the 'Buy' zone, then sell
            end
        else
            analyst_rec = "N/A" #if the chart isnot found, then 'N/A'
        end
        
        #get earning surprises
        surprises_url = "http://www.nasdaq.com/symbol/#{ticker}/earnings-surprise"
        surprises_doc = Nokogiri.HTML(open(URI.escape(surprises_url)))
        if surprises_doc.css("div.genTable td").any?
            surprises_chart = surprises_doc.css("div.genTable td")
            surprises_curr_quarter = surprises_chart[-1].text.to_f
            surprises_last_quarter = surprises_chart[-6].text.to_f
            surprises_last_2_quarter = surprises_chart[-11].text.to_f
        else
            surprises_curr_quarter = surprises_last_quarter = surprises_last_2_quarter = 0
        end
        
        
        Stock.create(name: ticker.upcase, 
                            price: price, 
                            rev_curr_year: rev_curr_year,
                            rev_last_year: rev_last_year,
                            rev_last_2_year: rev_last_2_year,
                            eps_curr_year: eps_curr_year,
                            eps_last_year: eps_last_year,
                            eps_last_2_year: eps_last_2_year,
                            dividends: dividends,
                            roe_curr_year: roe_curr_year,
                            roe_last_year: roe_last_year,
                            roe_last_2_year: roe_last_2_year,
                            analyst_rec: analyst_rec,
                            surprises_curr_quarter: surprises_curr_quarter,
                            surprises_last_quarter: surprises_last_quarter,
                            surprises_last_2_quarter: surprises_last_2_quarter
                            )
    end
end

# @tickers.each do |key, ticker|
#     Stock.create(name: ticker[:name], 
#                 price: ticker[:price], 
#                 rev_curr_year: ticker[:rev_curr_year])
    
    
# end