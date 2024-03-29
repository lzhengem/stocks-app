include ApplicationHelper

# uses the metrics found in http://www.nasdaq.com/investing/dozen/weighted-alpha.aspx
class Stock < ActiveRecord::Base
    PASS = "PASS" #set up PASS and FAIL constants
    FAIL = "FAIL"
    NA = "NA"
    
    def get_price
        ticker_doc = get_doc_from "http://www.nasdaq.com/symbol/#{name}"
        price = ticker_doc.css("div#qwidget_lastsale.qwidget-dollar").text.tr('$','').to_f
        price
    end
    
    def raise_exception_if_not_0_to_2(years_ago)
        unless [0,1,2].include? years_ago
            raise "Expected 0, 1, or 2 years ago"
        end
    end

    def get_total_rev(years_ago = 0)
        #if it gives a number other than 0,1,2 there is no data for that set
        raise_exception_if_not_0_to_2(years_ago)
        
        #get the revenue-eps page
        rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/revenue-eps")
        # begin
        #     doc = Nokogiri::HTML(open(url))
        #     rescue OpenURI::HTTPError => e
        #         puts "Can't access #{ url }"
        #         puts e.message
        #         puts
        #     next
        # end
        return_rev = 0
        if !rev_doc.is_a?(String) && rev_doc.css('iframe#frmMain').any?
                rev_chart_url = rev_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
                rev_chart_doc = get_doc_from(rev_chart_url)
                rev_chart = rev_chart_doc.css("td.body1")
                rev_headers = rev_chart_doc.css("td.body1 b")
            
                if rev_headers[-2] #if the chart is avaiable for this symbol get rev info
                    latest_month = rev_headers[-2].text
                    start = 0
                    rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
                    rev_info = rev_chart[start..-1] #contains all the relavent information rev_info 0-1 contains headers then 2-4 contains the info revenue from the last 3 years
                    #rev_info 5 is latest month eps header, 6-8 contains eps info for last 3 years
                    #rev_info 13 contains total headers, rev_info 14 contains total rev header
                    #if there is info in the latest month, then we can use totals to calculate rev and eps

                    #current year rev is at 15, last year's rev is at 16, 2 year's ago rev is at 17
                    return_rev = (rev_info[15 + years_ago]) ? rev_info[15 + years_ago].text.scan(/[\w+]/).join.get_full_number : 0
                end
        end
        return_rev.to_f
    end
    
    def get_latest_month_rev(years_ago = 0)
        #if it gives a number other than 0,1,2 there is no data for that set
        raise_exception_if_not_0_to_2(years_ago)
        
        rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/revenue-eps")
        if !rev_doc.is_a?(String) && rev_doc.css('iframe#frmMain').any?
            start = 0
            return_rev = 0
            rev_chart_url = rev_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
            rev_chart_doc = get_doc_from(rev_chart_url)
            rev_chart = rev_chart_doc.css("td.body1")
            rev_headers = rev_chart_doc.css("td.body1 b")
            
            #check which is the latest month with data
            if rev_headers[-3]
                latest_month = rev_headers[-3].text
                rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
                rev_info = rev_chart[start..-1]
    
                #latest month rev info is at 2, 1 year ago at index 3, 2 years ago at index 4
                return_rev = (rev_info[2 + years_ago]) ? rev_info[2 + years_ago].text.scan(/[\w+]/).join.get_full_number : 0
            end
        end
        return_rev.to_f
    end

    def get_rev_score
        # check if total rev is increasing
        if get_total_rev != 0
            # if the revenue of current year is greater than last year, and last year was greater than 2 years ago, then PASS
            rev_score = (get_total_rev > get_total_rev(1) and get_total_rev(1) > get_total_rev(2)) ? PASS : FAIL
        else
        # if total rev data is not available, use last month's rev data
            rev_score = (get_latest_month_rev > get_latest_month_rev(1) and get_latest_month_rev(1)> get_latest_month_rev(2)) ? PASS: FAIL
        end
        rev_score
    end
    
    def missing_info_for?(rev_or_eps)
        #get the revenue-eps page
        rev_or_eps_index = -24 if rev_or_eps == "rev" #latest month's rev info is at index -24
        rev_or_eps_index = -20 if rev_or_eps == "eps" #latest month's eps info is at index -20
        
        rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/revenue-eps")
        if !rev_doc.is_a?(String) && rev_doc.css('iframe#frmMain').any?
                rev_chart_url = rev_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
                rev_chart_doc = get_doc_from(rev_chart_url)
                rev_chart = rev_chart_doc.css("td.body1")
                rev_headers = rev_chart_doc.css("td.body1 b")
            
                if rev_headers[-2] #if the chart is avaiable for this symbol get rev info
                    latest_month = rev_headers[-2].text
                    start = 0
                    rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
                    # rev_chart[-24] contains the rev from the latest month
                    rev_info = rev_chart[rev_or_eps_index].text
                end
        end
        rev_info.blank?
    end
    
    # need to work on getting eps score
    def get_total_eps(years_ago = 0)
        #if it gives a number other than 0,1,2 there is no data for that set
        raise_exception_if_not_0_to_2(years_ago)
        
        return_eps =0
        #get eps information
        eps_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/revenue-eps")
        if !eps_doc.is_a?(String) && eps_doc.css('iframe#frmMain').any?
            eps_chart_url = eps_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
            eps_chart_doc = get_doc_from(eps_chart_url)
            eps_chart = eps_chart_doc.css("td.body1")
            eps_headers = eps_chart_doc.css("td.body1 b") 
        
            if eps_headers[-2] ##looking at the last quarter: December(FYE) if the chart is avaiable for this symbol get eps info
                latest_month = eps_headers[-2].text
                start = 0
                eps_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)} #looping through the December (FYE) info
                eps_info = eps_chart[start..-1]
                #eps this year is at index 19, last year at 20, 2 years ago at 21
                return_eps = (eps_info[19 + years_ago]) ? eps_info[19 + years_ago].text.to_f : 0
            end
        end
        return_eps.to_f
    end
    
    def get_latest_month_eps(years_ago = 0)
        #if it gives a number other than 0,1,2 there is no data for that set
        raise_exception_if_not_0_to_2(years_ago)
        
        #get eps information
        eps_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/revenue-eps")
        return_eps = 0
        if !eps_doc.is_a?(String) && eps_doc.css('iframe#frmMain').any?
            eps_chart_url = eps_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
            eps_chart_doc = get_doc_from(eps_chart_url)
            eps_chart = eps_chart_doc.css("td.body1")
            eps_headers = eps_chart_doc.css("td.body1 b") 
            start = 0
            
            if eps_headers[-3]
                latest_month = eps_headers[-3].text
                eps_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
                eps_info = eps_chart[start..-1]
    
                #eps latest month this year is at index 6, last year at 7, 2 years ago at 8
                return_eps = (eps_info[6 + years_ago]) ? eps_info[6 + years_ago].text.to_f : 0
            end
        end
        return_eps.to_f
    end

    # if the eps has been increasing from year to year, then it is a PASS
    def get_eps_score
        # check if total eps is increasing
        if get_total_eps != 0
            # if the eps of current year is greater than last year, and last year was greater than 2 years ago, then PASS
            eps_score = (get_total_eps > get_total_eps(1) and get_total_eps(1) > get_total_eps(2)) ? PASS : FAIL
        else
        # if total eps data is not available, use last month's eps data
            eps_score = (get_latest_month_eps > get_latest_month_eps(1) and get_latest_month_eps(1)> get_latest_month_eps(2)) ? PASS: FAIL
        end
        eps_score
    end
    
    def get_total_dividends
        dividends = 0
        rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/revenue-eps")
        if rev_doc && rev_doc.css('iframe#frmMain').any?
            rev_chart_url = rev_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
            rev_chart_doc = get_doc_from(rev_chart_url)
            rev_chart = rev_chart_doc.css("td.body1")
            rev_headers = rev_chart_doc.css("td.body1 b")
        
            if rev_headers[-2] #if the chart is avaiable for this symbol get rev info
                latest_month = rev_headers[-2].text
                start = 0
                rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
                rev_info = rev_chart[start..-1] #contains all the relavent information rev_info 0-1 contains headers then 2-4 contains the info revenue from the last 3 years
                
                #get dividends
                dividends = rev_info[23].text
            end
        end
        dividends.to_f
    end    
    
    # def get_latest_month_dividends
    #     dividends=0
    #     rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/revenue-eps")
    #     if rev_doc.css('iframe#frmMain').any?
    #         rev_chart_url = rev_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
    #         rev_chart_doc = get_doc_from(rev_chart_url)
    #         rev_chart = rev_chart_doc.css("td.body1")
    #         rev_headers = rev_chart_doc.css("td.body1 b")
        
    #         if rev_headers[-2] #if the chart is avaiable for this symbol get rev info
    #             latest_month = rev_headers[-2].text
    #             start = 0
    #             rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
    #             rev_info = rev_chart[start..-1] #contains all the relavent information rev_info 0-1 contains headers then 2-4 contains the info revenue from the last 3 years
                
    #             puts rev_info
    #             #get dividends
    #             dividends = rev_info[10].text
    #         end
    #     end
    #     dividends.to_f
    # end

    def get_roe(years_ago=0)
        # raise_exception_if_not_0_to_2(years_ago)
        roe_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/financials?query=ratios")
        if roe_doc
            roe_info = roe_doc.css("div#financials-iframe-wrap td")
            # roe_curr_year = roe_info[-4].text.to_f #the roe for the after-tax row current year is the 4th from last
            # roe_last_year = roe_info[-3].text.to_f
            # roe_last_2_year = roe_info[-2].text.to_f
            # roe for current year is at -4, last year at -3, 2 years ago at -2
            return_roe = (roe_info[-4 + years_ago]) ? roe_info[-4 + years_ago].text.to_f : 0
        end
            
        return_roe.to_i
    end

    # if the roe has been increasing for two consecutive years, then it is a PASS
    def get_roe_score
        # check if total roe is increasing
        if get_roe != 0
            # if the roe of current year is greater than last year, and last year was greater than 2 years ago, then PASS
            roe_score = (get_roe > get_roe(1) and get_roe(1) > get_roe(2)) ? PASS : FAIL
        else
        # if total roe data is not available, use last month's roe data
            roe_score = (get_roe > get_roe(1) and get_roe(1)> get_roe(2)) ? PASS: FAIL
        end
        roe_score
    end
    
    def get_rec
        analyst_rec = NA
        begin
            retries ||= 0 #allow it to try twice before quiting
            url = "http://www.nasdaq.com/charts/#{name}_rm.jpeg"
            rec_url = URI.parse(URI.escape(url))
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
                    analyst_rec = NA
                elsif analyst_x_coordinate > buy_x_coordinate #if the bar is in the 'Buy' zone, then Buy
                    analyst_rec = "Buy"
                else
                    analyst_rec = "Sell" #if the bar is not in the 'Buy' zone, then sell
                end
            end
        rescue Errno::ETIMEDOUT, OpenURI::HTTPError, Net::OpenTimeout => e
            retries +=1
            puts "Can't access #{ url }"
            puts e.message
            puts "Retry # #{retries}"
            puts
            retry if (retries) < 2
        end
        analyst_rec
    end
    
    # if the rec is "Buy" then it is a "Pasas"
    def get_rec_score
        # check if get_rec is a buy
        rec_score = (get_rec == "Buy") ? PASS : FAIL
        rec_score
    end
    
    def get_surprise(quarters_ago=0)
        raise_exception_if_not_0_to_2(quarters_ago)
        surprises_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/earnings-surprise")
        if surprises_doc && surprises_doc.css("div.genTable td").any? and surprises_doc.css("div.genTable td").count > 11
            surprises_chart = surprises_doc.css("div.genTable td")
            # current quarter at index -1, 1 quater ago at -6, 2 quaurters ago at -11
            return_surprises = surprises_chart[-1 - quarters_ago*5].text.to_f
        else
            return_surprises = 0
        end
        return_surprises
    end

    #year represents the future years
    def get_forecast(year=0)
        #get earnings forecast
        # forecast_url = "http://www.nasdaq.com/symbol/#{ticker}/earnings-forecast"
        # forecast_doc = Nokogiri.HTML(open(URI.escape(forecast_url)))
        # forecast_chart = forecast_doc.css("div.genTable").first.css("td")
        return_forecast = 0
        forecast_doc = get_doc_from "http://www.nasdaq.com/symbol/#{name}/earnings-forecast"
        if forecast_doc
            chart = forecast_doc.css("div.genTable").first
            
            if chart.css("td") #the information is stored here in the intervals 1,8,15... (x7 + 1)
                return_forecast = (chart.css("td")[7 * year + 1]) ? chart.css("td")[7 * year + 1].text.to_f : 0
                # end
            end
        end
        return_forecast
        
    end
    
    def get_growth
        #get earnings growth
        earnings_growth_digit = nil
        earnings_growth_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/earnings-growth")
        if earnings_growth_doc
            earnings_growth_digit = earnings_growth_doc.css("span#quotes_content_left_textinfo").text.scan(/\d+/).first
            earnings_growth_digit.nil? ? earnings_growth = nil : earnings_growth = earnings_growth_digit.to_f #it is the first digit in the paragraph
        end
        earnings_growth_digit
    end
    
    def get_short_interest
        # short interest - only avaiable for nasdaq-listed companies, for other companies, check NYSE website
        short_interest = -1 #if short_interest is negative, that means it wasn't found
        short_interest_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/short-interest")
        if short_interest_doc && short_interest_doc.css("table#quotes_content_left_ShortInterest1_ShortInterestGrid td").any?
            short_interest_chart = short_interest_doc.css("table#quotes_content_left_ShortInterest1_ShortInterestGrid td")
            short_interest = short_interest_chart[3].text.to_f if (short_interest_chart[3])
        end
        short_interest #if short interest is less than 2 days, then it is good
    end
    
    def get_insider
        #insider trading
        insider_trading = 0 #if insider_tranding = 0, there is no data
        insider_trading_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/insider-trades")
        if insider_trading_doc &&  insider_trading_doc.css("div.infoTable.floatL.marginT25px.paddingT10px td.center").any?
            insider_trading_chart = insider_trading_doc.css("div.infoTable.floatL.marginT25px.paddingT10px td.center")
            insider_trading_chart[-2].text.include?('(') ? insider_trading = -1 * insider_trading_chart[-2].text.scan(/\d+/).join.to_i : insider_trading = insider_trading_chart[-2].text.scan(/\d+/).join.to_i
        end
        insider_trading #if insider trader > 0, then it is good
    end
    
    def update
        
        
        # get revs for this year, last year, and the year before
        # get_total_rev is zero, then use get_total_rev. if get_total_rev is empty, then use get_latest_month_rev
        ##############################################################################################################
        # need to update this - total rev sometimes is avilable but not complete, so stock will fail if using total_rec. look at amzn for example
        if !get_total_rev.zero? and !missing_info_for?('rev')
            rev_curr_year = get_total_rev
            rev_last_year = get_total_rev(1)
            rev_last_2_year = get_total_rev(2)
        else
            rev_curr_year = get_latest_month_rev
            rev_last_year = get_latest_month_rev(1)
            rev_last_2_year = get_latest_month_rev(2)
        end
        
        # If rev score has been increasing year to year, PASS, if not, FAIL, if no data, then 'NA'
        rev_score = (rev_curr_year > rev_last_year && rev_last_year > rev_last_2_year) ? PASS : FAIL
        rev_score = NA if (rev_curr_year.zero? && rev_last_year.zero? && rev_last_2_year.zero?)
        
        # get eps for this year, last year, and the year before
        # get_total_eps is zero, then use get_total_eps. if get_total_eps is empty, then use get_latest_month_eps
        if !get_total_eps.zero? and !missing_info_for?('eps')
            eps_curr_year = get_total_eps
            eps_last_year = get_total_eps(1)
            eps_last_2_year = get_total_eps(2)
        else
            eps_curr_year = get_latest_month_eps
            eps_last_year = get_latest_month_eps(1)
            eps_last_2_year = get_latest_month_eps(2)
        end

        # If eps score has been increasing year to year, PASS, if not, FAIL, if no data, then 'NA'
        eps_score = (eps_curr_year > eps_last_year && eps_last_year > eps_last_2_year) ? PASS : FAIL
        eps_score = NA if (eps_curr_year.zero? || eps_last_year.zero? || eps_last_2_year.zero?)        
        
        # get the total dividens for this year so far
        dividends = get_total_dividends
        
        # get roe for this year, last year, and the year before
        roe_curr_year = get_roe
        roe_last_year = get_roe(1)
        roe_last_2_year = get_roe(2)
        
        # If roe has been increasing year to year, PASS, if not, FAIL, if no data, then 'NA'
        roe_score = (roe_curr_year > roe_last_year && roe_last_year > roe_last_2_year) ? PASS : FAIL
        roe_score = NA if (roe_curr_year.zero? || roe_last_year.zero? || roe_last_2_year.zero?)  
        
        # get recomendation
        analyst_rec = get_rec
        analyst_rec_score = (analyst_rec == "Buy") ? PASS : FAIL
        analyst_rec_score = analyst_rec if analyst_rec == NA
        
        # get surprises
        surprises_curr_quarter = get_surprise
        surprises_last_quarter = get_surprise(1)
        surprises_last_2_quarter = get_surprise(2)
        
        # if all surprises were positive, then PASS, if not, FAIL, if no data, then NA
        surprises_score = (surprises_curr_quarter >0 && surprises_last_quarter>0 && surprises_last_2_quarter>0) ? PASS : FAIL
        surprises_score = NA if (surprises_curr_quarter.zero? || surprises_last_quarter.zero? || surprises_last_2_quarter.zero?) 
        
        # get growth
        earnings_growth = get_growth
        
        # if earnings growth is > 8% at long term 5 year, then it PASSes, if no data, then NA
        earnings_growth_score = (earnings_growth.to_i > 8) ? PASS : FAIL
        earnings_growth_score =NA if earnings_growth.nil?
        
        # get short interest
        short_interest = get_short_interest
        
        # if short interest is less than 2, then PASS, if not, FAIL, if not found, then NA
        short_interest_score = (short_interest < 2) ? PASS : FAIL
        short_interest_score = NA if (short_interest_score == -1)
        
        # get insider trading
        insider_trading = get_insider
        
        # if insider trading is posivitive, then PASS, if negative, FAIL. if no data, then NA
        insider_trading_score = (insider_trading > 0) ? PASS : FAIL
        insider_trading_score =NA if (insider_trading.zero?)
        
        
        # get forecast
        forecast_year_0 = get_forecast
        forecast_year_1 = get_forecast(1)
        forecast_year_2 = get_forecast(2)
        # forecast_year_3 = get_forecast(3)
        
        # if forecast has been increasing then pass, else fail, if no data, then a
        forecast_score = (forecast_year_0 > forecast_year_1 && forecast_year_1 > forecast_year_2) ? PASS : FAIL
        forecast_score = NA if (forecast_year_0.zero? || forecast_year_1.zero? || forecast_year_2.zero?) 
        
        values = {
                            price: get_price, 
                            rev_curr_year: rev_curr_year,
                            rev_last_year: rev_last_year,
                            rev_last_2_year: rev_last_2_year,
                            rev_score: rev_score, #need to add the scores to the model
                            eps_curr_year: eps_curr_year,
                            eps_last_year: eps_last_year,
                            eps_last_2_year: eps_last_2_year,
                            eps_score: eps_score,
                            dividends: dividends,
                            roe_curr_year: roe_curr_year,
                            roe_last_year: roe_last_year,
                            roe_last_2_year: roe_last_2_year,
                            roe_score: roe_score,
                            analyst_rec: analyst_rec,
                            analyst_rec_score: analyst_rec_score,
                            surprises_curr_quarter: surprises_curr_quarter,
                            surprises_last_quarter: surprises_last_quarter,
                            surprises_last_2_quarter: surprises_last_2_quarter,
                            surprises_score: surprises_score,
                            earnings_growth: earnings_growth,
                            earnings_growth_score: earnings_growth_score,
                            short_interest: short_interest,
                            short_interest_score: short_interest_score,
                            insider_trading: insider_trading,
                            insider_trading_score: insider_trading_score,
                            forecast_year_0: forecast_year_0,
                            forecast_year_1: forecast_year_1,
                            forecast_year_2: forecast_year_2,
                            forecast_year_3: forecast_year_3,
                            forecast_score: forecast_score,
        }
            
        update_attributes(values)
        pass_count = 0
        fail_count =0
        attributes.keys.select{|a| a.include?('score')}.each do |score| #count all the scores for FAIL/PASS
            if self[score] == PASS
                pass_count += 1
            elsif self[score] == FAIL
                fail_count += 1
            end
        end
        update_attributes({pass_count:pass_count, fail_count: fail_count} )
        
    end
    
end
