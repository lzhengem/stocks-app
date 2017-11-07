module ApplicationHelper
    class Object::String
        
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
    
    # opens the webpage and returns it as nokogiri. if there is an error, returns nil
    def get_doc_from(url)
        doc = nil
        # need to rescue if thte connection times out or if the page is not found
        begin
            retries ||= 0 #allow it to try twice before quiting
            opened_uri = open(URI.escape(url),:read_timeout => 600, :open_timeout =>600)
            doc = Nokogiri.HTML(opened_uri) #set thereadtimeout to600 so hopefully wont get Net::OpenTimeout: execution expired error again
            opened_uri.close #close the connection
        rescue Errno::ETIMEDOUT, OpenURI::HTTPError, Net::OpenTimeout => e
            retries +=1
            puts "Can't access #{ url }"
            puts e.message
            puts "Retry # #{retries}"
            puts
            retry if (retries) < 2
        end
        doc
    end
    
    def tickers_for_letter(letter)
        # look at the page for the letter entered, ex: A
        firstdoc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}&pagesize=200"
        # find the last page for letter=A
        if firstdoc && firstdoc.css("a#two_column_main_content_lb_LastPage").any?
            last_page = firstdoc.css("a#two_column_main_content_lb_LastPage").attribute('href').value.scan(/page=(\d+)/)[0][0].to_i
        else
            last_page = 1
        end
        # collect all the tickers for letter A
        tickers = []
        (1..last_page).each do |page|
            doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}&pagesize=200&page=#{page}"
            if doc
                doc.css('h3').map do |link|
                    tickers << link.content.strip.downcase
                end
            end
        end
        tickers
    end
    
    # def price_for(ticker)
    #     ticker_doc = get_doc_from "http://www.nasdaq.com/symbol/#{ticker}"
    #     {price: ticker_doc.css("div#qwidget_lastsale.qwidget-dollar").text.tr('$','').to_f}
    # end
    
    # def rev_for(ticker)
    #     rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/revenue-eps")
    #     if rev_doc.css('iframe#frmMain').any?
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
                    
    #                 if rev_curr_year.zero? #if info for the latest month is missing, instead of using totals, use previous month
    #                     latest_month = rev_headers[-3].text
    #                     rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
    #                     rev_info = rev_chart[start..-1]
    #                     rev_curr_year = rev_info[2].text.scan(/[\w+]/).join.get_full_number
    #                     rev_last_year = rev_info[3].text.scan(/[\w+]/).join.get_full_number
    #                     rev_last_2_year = rev_info[4].text.scan(/[\w+]/).join.get_full_number
    #                 end
    #             else
    #                 rev_curr_year = rev_last_year = rev_last_2_year = 0
    #             end
    #     else
    #         rev_curr_year = rev_last_year = rev_last_2_year = 0
    #     end
        
    #     if rev_curr_year ==  0
    #         rev_score = "N/A"
    #     elsif rev_curr_year > rev_last_year and rev_last_year > rev_last_2_year
    #         rev_score = "Pass"
    #     else 
    #         rev_score = "Fail"
    #     end
    #     {rev_curr_year: rev_curr_year, rev_last_year: rev_curr_year, rev_last_2_year: rev_last_2_year, rev_score: rev_score}
    # end
    
    def ascending? arr #checks if the array is increasing
      arr.reduce{ |num1,num2| num1 <= num2 ? num2 : (return false) }; true
    end
    
    
    
end
