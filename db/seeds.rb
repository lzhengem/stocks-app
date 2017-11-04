# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
include ApplicationHelper

require 'open-uri'
require 'nokogiri'

class String
    
    #converts 100t -> 100000
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
puts "start time: #{Time.now}"

# do it page by page
letter = 'A'
first_doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}&pagesize=200"
if first_doc.css("a#two_column_main_content_lb_LastPage").any?
    last_page = first_doc.css("a#two_column_main_content_lb_LastPage").attribute('href').value.scan(/page=(\d+)/)[0][0].to_i
else
    last_page = 1
end
tickers = []
# (1..last_page).each do |page|
(1..1).each do |page|
    doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}&pagesize=200&page=#{page}"
    doc.css('h3').map do |link|
        ticker = link.content.strip.upcase
        tickers << ticker
    end
end
# if stopped in the middle, just reuse the next and continue
start =144
# new_ticker =tickers[start..start+50]
new_ticker =tickers[start..-1]
new_ticker.each_with_index do |ticker, index|
    puts "working on #{ticker}, index #{index + start}"
    if stock = Stock.find_by(name: ticker.downcase)
        stock.destroy
    end
    new_stock = Stock.new(name: ticker.downcase)
    new_stock.update
end
# tickers.index "AEZS"



# #if the seeding stops at any area, use this to finish the end of the page.
# letter = "H"
# first_page = 2
# last_page = 2
# ticker_num = 0
# # ticker = "hbk" #use this to find the ticker from console
# # ticker_num = doc.css('h3').map {|link| link.content.strip.downcase}.index(ticker)

# (first_page..last_page).each do |page|
#     doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}&pagesize=200&page=#{page}" #going to keep gong from ELS
#     ticker_num = 0 if page != first_page
#     doc.css('h3')[ticker_num..-1].map do |link| #need to find out which ticker it stopped at. replace 41 els was at 41
#         ticker = link.content.strip.downcase
#         pass_count = 0
#         fail_count = 0
        
#         #get price info
#         ticker_doc = get_doc_from "http://www.nasdaq.com/symbol/#{ticker}"
#         price = ticker_doc.css("div#qwidget_lastsale.qwidget-dollar").text.tr('$','').to_f
        
#         #get revenue information
#         rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/revenue-eps")
#         if rev_doc.css('iframe#frmMain').any?
#             rev_chart_url = rev_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
#             rev_chart_doc = get_doc_from(rev_chart_url)
#             rev_chart = rev_chart_doc.css("td.body1")
#             rev_headers = rev_chart_doc.css("td.body1 b")
        
#             if rev_headers[-2] #if the chart is avaiable for this symbol get rev info
#                 latest_month = rev_headers[-2].text
#                 start = 0
#                 rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
#                 rev_info = rev_chart[start..-1] #contains all the relavent information rev_info 0-1 contains headers then 2-4 contains the info revenue from the last 3 years
#                 #rev_info 5 is latest month eps header, 6-8 contains eps info for last 3 years
#                 #rev_info 13 contains total headers, rev_info 14 contains total rev header
#                 #if there is info in the latest month, then we can use totals to calculate rev and eps
#                 rev_curr_year = rev_info[15].text.scan(/[\w+]/).join.get_full_number
#                 rev_last_year = rev_info[16].text.scan(/[\w+]/).join.get_full_number
#                 rev_last_2_year = rev_info[17].text.scan(/[\w+]/).join.get_full_number
                
#                 #get eps info
#                 eps_curr_year = rev_info[19].text.to_f
#                 eps_last_year = rev_info[20].text.to_f
#                 eps_last_2_year = rev_info[21].text.to_f
                
#                 #get dividends
#                 dividends = rev_info[23].text
                
#                 if rev_curr_year.zero? #if info for the latest month is missing, instead of using totals, use previous month
#                     latest_month = rev_headers[-3].text
#                     rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
#                     rev_info = rev_chart[start..-1]
#                     rev_curr_year = rev_info[2].text.scan(/[\w+]/).join.get_full_number
#                     rev_last_year = rev_info[3].text.scan(/[\w+]/).join.get_full_number
#                     rev_last_2_year = rev_info[4].text.scan(/[\w+]/).join.get_full_number
                    
#                     #get eps info    
#                     eps_curr_year = rev_info[6].text.to_f
#                     eps_last_year = rev_info[7].text.to_f
#                     eps_last_2_year = rev_info[8].text.to_f
                    
#                     #get dividends
#                     dividends = rev_info[10].text
                    
#                 end
#             else
#                 rev_curr_year = rev_last_year = rev_last_2_year = eps_curr_year = eps_last_year = eps_last_2_year = 0
#                 dividends = "N/A"
#             end
#         else
#             rev_curr_year = rev_last_year = rev_last_2_year = eps_curr_year = eps_last_year = eps_last_2_year = 0
#             dividends = "N/A"
#         end
        
#         if rev_curr_year ==  0
#             rev_score = "N/A"
#         elsif rev_curr_year > rev_last_year and rev_last_year > rev_last_2_year
#             rev_score = "Pass"
#             pass_count += 1
#         else 
#             rev_score = "Fail"
#             fail_count += 1
#         end
            
#         if eps_curr_year ==  0
#             eps_score = "N/A"
#         elsif eps_curr_year > eps_last_year and eps_last_year > eps_last_2_year
#             eps_score = "Pass"
#             pass_count += 1
#         else 
#             eps_score = "Fail"
#             fail_count += 1
#         end
        
#         # get return on equity ROE
#         roe_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/financials?query=ratios")
#         if (roe_info = roe_doc.css("div#financials-iframe-wrap td")).any?
#             roe_curr_year = roe_info[-4].text.to_f #the roe for the current year is the 4th from last
#             roe_last_year = roe_info[-3].text.to_f
#             roe_last_2_year = roe_info[-2].text.to_f
#         else
#             roe_curr_year = roe_last_year = roe_last_2_year = 0
#         end
        
#         if roe_curr_year.zero?
#             roe_score = "N/A"
#         elsif roe_curr_year > roe_last_year and roe_last_year > roe_last_2_year
#             roe_score = "Pass"
#             pass_count += 1
#         else
#             roe_score = "Fail"
#             fail_count += 1
#         end
        
#         #get analyst recomendations
#         rec_url = URI.parse(URI.escape("http://www.nasdaq.com/charts/#{ticker}_rm.jpeg"))
#         rec_req = Net::HTTP.new(rec_url.host, rec_url.port) #sometimes this chart is not avaiable, so check to see if its there
#         rec_res = rec_req.request_head(rec_url.path)
#         if rec_res.code == '200' #if it exists, then parse the image
#             image = Magick::ImageList.new  
#             urlimage = open(rec_url) # Image Remote URL 
#             image.from_blob(urlimage.read)
#             buy_x_coordinate = 206 #if the first blue line is at the x coordinate 206, then it is a "buy" recommendation
#             analyst_x_coordinate = 0 #find the analyst recomendation x coordinate of the bar
#             (0..image.columns).each do |x|
#                 (0..image.rows).each do |y|
#                     pixel = image.pixel_color(x, y)
#                     if pixel.blue/256 > 220 and pixel.red/256 <100 and pixel.green/256 <100
#                         analyst_x_coordinate = x
#                         break 
#                     end
#                 end
#                 break if analyst_x_coordinate > 0
#             end
            
#             if analyst_x_coordinate == 0 #if the bar is not found, then give 'N/A'
#                 analyst_rec = "N/A"
#             elsif analyst_x_coordinate > buy_x_coordinate #if the bar is in the 'Buy' zone, then Buy
#                 analyst_rec = "Buy"
#             else
#                 analyst_rec = "Sell" #if the bar is not in the 'Buy' zone, then sell
#             end
#         else
#             analyst_rec = "N/A" #if the chart isnot found, then 'N/A'
#         end
        
#         if analyst_rec == "N/A"
#             analyst_rec_score = "N/A"
#         elsif analyst_rec == "Buy"
#             analyst_rec_score = "Pass"
#             pass_count += 1
#         else
#             analyst_rec_score = "Fail"
#             fail_count += 1
#         end
                
        
#         #get earning surprises
#         surprises_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/earnings-surprise")
#         if surprises_doc.css("div.genTable td").any? and surprises_doc.css("div.genTable td").count > 11
#             surprises_chart = surprises_doc.css("div.genTable td")
#             surprises_curr_quarter = surprises_chart[-1].text.to_f
#             surprises_last_quarter = surprises_chart[-6].text.to_f
#             surprises_last_2_quarter = surprises_chart[-11].text.to_f
#         else
#             surprises_curr_quarter = surprises_last_quarter = surprises_last_2_quarter = 0
#         end
        
#         if surprises_curr_quarter.zero?
#             surprises_score = "N/A"
#         elsif surprises_curr_quarter > 0 and surprises_last_quarter > 0 and surprises_last_2_quarter > 0
#             surprises_score = "Pass"
#             pass_count += 1
#         else
#             surprises_score = "Fail"
#             fail_count += 1
#         end
                
        
#         #get earnings forecast
#         # forecast_url = "http://www.nasdaq.com/symbol/#{ticker}/earnings-forecast"
#         # forecast_doc = Nokogiri.HTML(open(URI.escape(forecast_url)))
#         # forecast_chart = forecast_doc.css("div.genTable").first.css("td")
#         forecast_doc = get_doc_from "http://www.nasdaq.com/symbol/#{ticker}/earnings-forecast"
#         chart = forecast_doc.css("div.genTable").first
#         forecast_array =[]
#         if chart.css("td") #the information is stored here in the intervals 1,8,15... (x7 + 1)
#             num_forecast = (chart.css("td").count / 7) - 1 #find out how many forecasts we have. minus 1 because of 0 indexing
#             0.upto(num_forecast) do |num| #collect all the forecasts into forecast_array
#                 forecast_array[num] = chart.css("td")[7 * num + 1].text.to_f
#             end
#         end
        
#         if forecast_array.empty?
#             forecast_score = "N/A"
#         elsif ascending? forecast_array
#             pass_count += 1
#             forecast_score = "Pass"
#         else
#             fail_count += 1
#             forecast_score = "Fail"
#         end
        
#         #get earnings growth
#         earnings_growth_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/earnings-growth")
#         earnings_growth_digit = earnings_growth_doc.css("span#quotes_content_left_textinfo").text.scan(/\d+/).first
#         earnings_growth_digit.nil? ? earnings_growth = nil : earnings_growth = earnings_growth_digit.to_f #it is the first digit in the paragraph
#         if earnings_growth.nil?
#             earnings_growth_score = "N/A"
#         elsif earnings_growth > 0
#             earnings_growth_score = "Pass"
#             pass_count += 1
#         else
#             earnings_growth_score = "Fail"
#             fail_count += 1
#         end
        
                
        
#         # short interest - only avaiable for nasdaq-listed companies, for other companies, check NYSE website
#         short_interest_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/short-interest")
#         if short_interest_doc.css("table#quotes_content_left_ShortInterest1_ShortInterestGrid td").any?
#             short_interest_chart = short_interest_doc.css("table#quotes_content_left_ShortInterest1_ShortInterestGrid td")
#             short_interest = short_interest_chart[3].text.to_f
#         else
#             short_interest = -1
#         end
        
#         if short_interest == -1
#             short_interest_score = "N/A"
#         elsif short_interest < 2        #if its less than 2 days, then it passes
#             short_interest_score = "Pass"
#             pass_count += 1
#         else
#             short_interest_score = "Fail"
#             fail_count += 1
#         end
                
        
#         #insider trading
#         insider_trading_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/insider-trades")
#         if insider_trading_doc.css("div.infoTable.floatL.marginT25px.paddingT10px td.center").any?
#             insider_trading_chart = insider_trading_doc.css("div.infoTable.floatL.marginT25px.paddingT10px td.center")
#             insider_trading_chart[-2].text.include?('(') ? insider_trading = -1 * insider_trading_chart[-2].text.scan(/\d+/).join.to_i : insider_trading = insider_trading_chart[-2].text.scan(/\d+/).join.to_i
#         else
#             insider_trading = 0
#         end
#         if insider_trading == 0
#             insider_trading_score = "N/A"
#         elsif insider_trading > 0
#             insider_trading_score = "Pass"
#             pass_count += 1
#         else
#             insider_trading_score = "Fail"
#             fail_count +=1
#         end
        
#         # weighted alpha - you can to search for the company, then click on the second link - however, nokogiri was not able to find the link...
#         # sector_doc = get_doc_from "http://www.nasdaq.com/markets/barchart-sectors.aspx?sym=#{ticker}"
        
            
        
#         Stock.create(name: ticker.upcase, 
#                             price: price, 
#                             rev_curr_year: rev_curr_year,
#                             rev_last_year: rev_last_year,
#                             rev_last_2_year: rev_last_2_year,
#                             rev_score: rev_score, #need to add the scores to the model
#                             eps_curr_year: eps_curr_year,
#                             eps_last_year: eps_last_year,
#                             eps_last_2_year: eps_last_2_year,
#                             eps_score: eps_score,
#                             dividends: dividends,
#                             roe_curr_year: roe_curr_year,
#                             roe_last_year: roe_last_year,
#                             roe_last_2_year: roe_last_2_year,
#                             roe_score: roe_score,
#                             analyst_rec: analyst_rec,
#                             analyst_rec_score: analyst_rec_score,
#                             surprises_curr_quarter: surprises_curr_quarter,
#                             surprises_last_quarter: surprises_last_quarter,
#                             surprises_last_2_quarter: surprises_last_2_quarter,
#                             surprises_score: surprises_score,
#                             earnings_growth: earnings_growth,
#                             earnings_growth_score: earnings_growth_score,
#                             short_interest: short_interest,
#                             short_interest_score: short_interest_score,
#                             insider_trading: insider_trading,
#                             insider_trading_score: insider_trading_score,
#                             forecast_year_0: forecast_array[0],
#                             forecast_year_1: forecast_array[1],
#                             forecast_year_2: forecast_array[2],
#                             forecast_year_3: forecast_array[3],
#                             forecast_score: forecast_score,
#                             pass_count: pass_count,
#                             fail_count: fail_count
#                             )
#     end
# end

# ('A'..'Z').each do |letter| #got stopped at ELS, so continue from F
#     first_doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}&pagesize=200"
#     if first_doc.css("a#two_column_main_content_lb_LastPage").any?
#         last_page = first_doc.css("a#two_column_main_content_lb_LastPage").attribute('href').value.scan(/page=(\d+)/)[0][0].to_i
#     else
#         last_page = 1
#     end
    
#     (1..last_page).each do |page|
#         doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}&pagesize=200&page=#{page}"
#         doc.css('h3').map do |link|
#             ticker = link.content.strip.downcase
#             pass_count = 0
#             fail_count = 0
            
#             #get price info
#             ticker_doc = get_doc_from "http://www.nasdaq.com/symbol/#{ticker}"
#             price = ticker_doc.css("div#qwidget_lastsale.qwidget-dollar").text.tr('$','').to_f
            
#             #get revenue information
#             rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/revenue-eps")
#             if rev_doc.css('iframe#frmMain').any?
#                 rev_chart_url = rev_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
#                 rev_chart_doc = get_doc_from(rev_chart_url)
#                 rev_chart = rev_chart_doc.css("td.body1")
#                 rev_headers = rev_chart_doc.css("td.body1 b")
            
#                 if rev_headers[-2] #if the chart is avaiable for this symbol get rev info
#                     latest_month = rev_headers[-2].text
#                     start = 0
#                     rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
#                     rev_info = rev_chart[start..-1] #contains all the relavent information rev_info 0-1 contains headers then 2-4 contains the info revenue from the last 3 years
#                     #rev_info 5 is latest month eps header, 6-8 contains eps info for last 3 years
#                     #rev_info 13 contains total headers, rev_info 14 contains total rev header
#                     #if there is info in the latest month, then we can use totals to calculate rev and eps
#                     rev_curr_year = rev_info[15].text.scan(/[\w+]/).join.get_full_number
#                     rev_last_year = rev_info[16].text.scan(/[\w+]/).join.get_full_number
#                     rev_last_2_year = rev_info[17].text.scan(/[\w+]/).join.get_full_number
                    
#                     #get eps info
#                     eps_curr_year = rev_info[19].text.to_f
#                     eps_last_year = rev_info[20].text.to_f
#                     eps_last_2_year = rev_info[21].text.to_f
                    
#                     #get dividends
#                     dividends = rev_info[23].text
                    
#                     if rev_curr_year.zero? #if info for the latest month is missing, instead of using totals, use previous month
#                         latest_month = rev_headers[-3].text
#                         rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
#                         rev_info = rev_chart[start..-1]
#                         rev_curr_year = rev_info[2].text.scan(/[\w+]/).join.get_full_number
#                         rev_last_year = rev_info[3].text.scan(/[\w+]/).join.get_full_number
#                         rev_last_2_year = rev_info[4].text.scan(/[\w+]/).join.get_full_number
                        
#                         #get eps info    
#                         eps_curr_year = rev_info[6].text.to_f
#                         eps_last_year = rev_info[7].text.to_f
#                         eps_last_2_year = rev_info[8].text.to_f
                        
#                         #get dividends
#                         dividends = rev_info[10].text
                        
#                     end
#                 else
#                     rev_curr_year = rev_last_year = rev_last_2_year = eps_curr_year = eps_last_year = eps_last_2_year = 0
#                     dividends = "N/A"
#                 end
#             else
#                 rev_curr_year = rev_last_year = rev_last_2_year = eps_curr_year = eps_last_year = eps_last_2_year = 0
#                 dividends = "N/A"
#             end
            
#             if rev_curr_year ==  0
#                 rev_score = "N/A"
#             elsif rev_curr_year > rev_last_year and rev_last_year > rev_last_2_year
#                 rev_score = "Pass"
#                 pass_count += 1
#             else 
#                 rev_score = "Fail"
#                 fail_count += 1
#             end
                
#             if eps_curr_year ==  0
#                 eps_score = "N/A"
#             elsif eps_curr_year > eps_last_year and eps_last_year > eps_last_2_year
#                 eps_score = "Pass"
#                 pass_count += 1
#             else 
#                 eps_score = "Fail"
#                 fail_count += 1
#             end
            
#             # get return on equity ROE
#             roe_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/financials?query=ratios")
#             if (roe_info = roe_doc.css("div#financials-iframe-wrap td")).any?
#                 roe_curr_year = roe_info[-4].text.to_f #the roe for the current year is the 4th from last
#                 roe_last_year = roe_info[-3].text.to_f
#                 roe_last_2_year = roe_info[-2].text.to_f
#             else
#                 roe_curr_year = roe_last_year = roe_last_2_year = 0
#             end
            
#             if roe_curr_year.zero?
#                 roe_score = "N/A"
#             elsif roe_curr_year > roe_last_year and roe_last_year > roe_last_2_year
#                 roe_score = "Pass"
#                 pass_count += 1
#             else
#                 roe_score = "Fail"
#                 fail_count += 1
#             end
            
#             #get analyst recomendations
#             rec_url = URI.parse(URI.escape("http://www.nasdaq.com/charts/#{ticker}_rm.jpeg"))
#             rec_req = Net::HTTP.new(rec_url.host, rec_url.port) #sometimes this chart is not avaiable, so check to see if its there
#             rec_res = rec_req.request_head(rec_url.path)
#             if rec_res.code == '200' #if it exists, then parse the image
#                 image = Magick::ImageList.new  
#                 urlimage = open(rec_url) # Image Remote URL 
#                 image.from_blob(urlimage.read)
#                 buy_x_coordinate = 206 #if the first blue line is at the x coordinate 206, then it is a "buy" recommendation
#                 analyst_x_coordinate = 0 #find the analyst recomendation x coordinate of the bar
#                 (0..image.columns).each do |x|
#                     (0..image.rows).each do |y|
#                         pixel = image.pixel_color(x, y)
#                         if pixel.blue/256 > 220 and pixel.red/256 <100 and pixel.green/256 <100
#                             analyst_x_coordinate = x
#                             break 
#                         end
#                     end
#                     break if analyst_x_coordinate > 0
#                 end
                
#                 if analyst_x_coordinate == 0 #if the bar is not found, then give 'N/A'
#                     analyst_rec = "N/A"
#                 elsif analyst_x_coordinate > buy_x_coordinate #if the bar is in the 'Buy' zone, then Buy
#                     analyst_rec = "Buy"
#                 else
#                     analyst_rec = "Sell" #if the bar is not in the 'Buy' zone, then sell
#                 end
#             else
#                 analyst_rec = "N/A" #if the chart isnot found, then 'N/A'
#             end
            
#             if analyst_rec == "N/A"
#                 analyst_rec_score = "N/A"
#             elsif analyst_rec == "Buy"
#                 analyst_rec_score = "Pass"
#                 pass_count += 1
#             else
#                 analyst_rec_score = "Fail"
#                 fail_count += 1
#             end
                    
            
#             #get earning surprises
#             surprises_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/earnings-surprise")
#             if surprises_doc.css("div.genTable td").any? and surprises_doc.css("div.genTable td").count > 11
#                 surprises_chart = surprises_doc.css("div.genTable td")
#                 surprises_curr_quarter = surprises_chart[-1].text.to_f
#                 surprises_last_quarter = surprises_chart[-6].text.to_f
#                 surprises_last_2_quarter = surprises_chart[-11].text.to_f
#             else
#                 surprises_curr_quarter = surprises_last_quarter = surprises_last_2_quarter = 0
#             end
            
#             if surprises_curr_quarter.zero?
#                 surprises_score = "N/A"
#             elsif surprises_curr_quarter > 0 and surprises_last_quarter > 0 and surprises_last_2_quarter > 0
#                 surprises_score = "Pass"
#                 pass_count += 1
#             else
#                 surprises_score = "Fail"
#                 fail_count += 1
#             end
                    
            
#             #get earnings forecast
#             # forecast_url = "http://www.nasdaq.com/symbol/#{ticker}/earnings-forecast"
#             # forecast_doc = Nokogiri.HTML(open(URI.escape(forecast_url)))
#             # forecast_chart = forecast_doc.css("div.genTable").first.css("td")
#             forecast_doc = get_doc_from "http://www.nasdaq.com/symbol/#{ticker}/earnings-forecast"
#             chart = forecast_doc.css("div.genTable").first
#             forecast_array =[]
#             if chart.css("td") #the information is stored here in the intervals 1,8,15... (x7 + 1)
#                 num_forecast = (chart.css("td").count / 7) - 1 #find out how many forecasts we have. minus 1 because of 0 indexing
#                 0.upto(num_forecast) do |num| #collect all the forecasts into forecast_array
#                     forecast_array[num] = chart.css("td")[7 * num + 1].text.to_f
#                 end
#             end
            
#             if forecast_array.empty?
#                 forecast_score = "N/A"
#             elsif ascending? forecast_array
#                 pass_count += 1
#                 forecast_score = "Pass"
#             else
#                 fail_count += 1
#                 forecast_score = "Fail"
#             end
            
#             #get earnings growth
#             earnings_growth_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/earnings-growth")
#             earnings_growth_digit = earnings_growth_doc.css("span#quotes_content_left_textinfo").text.scan(/\d+/).first
#             earnings_growth_digit.nil? ? earnings_growth = nil : earnings_growth = earnings_growth_digit.to_f #it is the first digit in the paragraph
#             if earnings_growth.nil?
#                 earnings_growth_score = "N/A"
#             elsif earnings_growth > 0
#                 earnings_growth_score = "Pass"
#                 pass_count += 1
#             else
#                 earnings_growth_score = "Fail"
#                 fail_count += 1
#             end
            
                    
            
#             # short interest - only avaiable for nasdaq-listed companies, for other companies, check NYSE website
#             short_interest_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/short-interest")
#             if short_interest_doc.css("table#quotes_content_left_ShortInterest1_ShortInterestGrid td").any?
#                 short_interest_chart = short_interest_doc.css("table#quotes_content_left_ShortInterest1_ShortInterestGrid td")
#                 short_interest = short_interest_chart[3].text.to_f
#             else
#                 short_interest = -1
#             end
            
#             if short_interest == -1
#                 short_interest_score = "N/A"
#             elsif short_interest < 2        #if its less than 2 days, then it passes
#                 short_interest_score = "Pass"
#                 pass_count += 1
#             else
#                 short_interest_score = "Fail"
#                 fail_count += 1
#             end
                    
            
#             #insider trading
#             insider_trading_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/insider-trades")
#             if insider_trading_doc.css("div.infoTable.floatL.marginT25px.paddingT10px td.center").any?
#                 insider_trading_chart = insider_trading_doc.css("div.infoTable.floatL.marginT25px.paddingT10px td.center")
#                 insider_trading_chart[-2].text.include?('(') ? insider_trading = -1 * insider_trading_chart[-2].text.scan(/\d+/).join.to_i : insider_trading = insider_trading_chart[-2].text.scan(/\d+/).join.to_i
#             else
#                 insider_trading = 0
#             end
#             if insider_trading == 0
#                 insider_trading_score = "N/A"
#             elsif insider_trading > 0
#                 insider_trading_score = "Pass"
#                 pass_count += 1
#             else
#                 insider_trading_score = "Fail"
#                 fail_count +=1
#             end
            
#             # weighted alpha - you can to search for the company, then click on the second link - however, nokogiri was not able to find the link...
#             # sector_doc = get_doc_from "http://www.nasdaq.com/markets/barchart-sectors.aspx?sym=#{ticker}"
            
                
            
#             Stock.create(name: ticker.upcase, 
#                                 price: price, 
#                                 rev_curr_year: rev_curr_year,
#                                 rev_last_year: rev_last_year,
#                                 rev_last_2_year: rev_last_2_year,
#                                 rev_score: rev_score, #need to add the scores to the model
#                                 eps_curr_year: eps_curr_year,
#                                 eps_last_year: eps_last_year,
#                                 eps_last_2_year: eps_last_2_year,
#                                 eps_score: eps_score,
#                                 dividends: dividends,
#                                 roe_curr_year: roe_curr_year,
#                                 roe_last_year: roe_last_year,
#                                 roe_last_2_year: roe_last_2_year,
#                                 roe_score: roe_score,
#                                 analyst_rec: analyst_rec,
#                                 analyst_rec_score: analyst_rec_score,
#                                 surprises_curr_quarter: surprises_curr_quarter,
#                                 surprises_last_quarter: surprises_last_quarter,
#                                 surprises_last_2_quarter: surprises_last_2_quarter,
#                                 surprises_score: surprises_score,
#                                 earnings_growth: earnings_growth,
#                                 earnings_growth_score: earnings_growth_score,
#                                 short_interest: short_interest,
#                                 short_interest_score: short_interest_score,
#                                 insider_trading: insider_trading,
#                                 insider_trading_score: insider_trading_score,
#                                 forecast_year_0: forecast_array[0],
#                                 forecast_year_1: forecast_array[1],
#                                 forecast_year_2: forecast_array[2],
#                                 forecast_year_3: forecast_array[3],
#                                 forecast_score: forecast_score,
#                                 pass_count: pass_count,
#                                 fail_count: fail_count
#                                 )
#         end
#     end
# end

puts "end time: #{Time.now}"