include ApplicationHelper

class Stock < ActiveRecord::Base
    def get_price
        ticker_doc = get_doc_from "http://www.nasdaq.com/symbol/#{name}"
        {price: ticker_doc.css("div#qwidget_lastsale.qwidget-dollar").text.tr('$','').to_f}
    end
    
    def get_rev
        rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/revenue-eps")
        if rev_doc.css('iframe#frmMain').any?
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
                    rev_curr_year = rev_info[15].text.scan(/[\w+]/).join.get_full_number
                    rev_last_year = rev_info[16].text.scan(/[\w+]/).join.get_full_number
                    rev_last_2_year = rev_info[17].text.scan(/[\w+]/).join.get_full_number
                    
                    if rev_curr_year.zero? #if info for the latest month is missing, instead of using totals, use previous month
                        latest_month = rev_headers[-3].text
                        rev_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}
                        rev_info = rev_chart[start..-1]
                        rev_curr_year = rev_info[2].text.scan(/[\w+]/).join.get_full_number
                        rev_last_year = rev_info[3].text.scan(/[\w+]/).join.get_full_number
                        rev_last_2_year = rev_info[4].text.scan(/[\w+]/).join.get_full_number
                    end
                else
                    rev_curr_year = rev_last_year = rev_last_2_year = 0
                end
        else
            rev_curr_year = rev_last_year = rev_last_2_year = 0
        end
        
        if rev_curr_year ==  0
            rev_score = "N/A"
        elsif rev_curr_year > rev_last_year and rev_last_year > rev_last_2_year
            rev_score = "Pass"
        else 
            rev_score = "Fail"
        end
        {rev_curr_year: rev_curr_year, rev_last_year: rev_curr_year, rev_last_2_year: rev_last_2_year, rev_score: rev_score}
    end
    
    def get_eps
        #get eps information
        eps_doc = get_doc_from("http://www.nasdaq.com/symbol/#{name}/revenue-eps")
        if eps_doc.css('iframe#frmMain').any?
            eps_chart_url = eps_doc.css('iframe#frmMain').first['src'] #gets the page where the chart resides
            eps_chart_doc = get_doc_from(eps_chart_url)
            eps_chart = eps_chart_doc.css("td.body1")
            eps_headers = eps_chart_doc.css("td.body1 b") 
        
            if eps_headers[-2] ##looking at the last quarter: December(FYE) if the chart is avaiable for this symbol get eps info
                latest_month = eps_headers[-2].text
                start = 0
                eps_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)} #looping through the December (FYE) info
                eps_info = eps_chart[start..-1]
                #get eps info
                eps_curr_year = eps_info[19].text.to_f
                eps_last_year = eps_info[20].text.to_f
                eps_last_2_year = eps_info[21].text.to_f
                
                if eps_curr_year.zero? #if info for the latest month is missing, instead of using totals, use pepsious month
                    latest_month = eps_headers[-3].text
                    eps_chart.each_with_index{|node, index| start = index if node.text.include?(latest_month)}

                    #get eps info    
                    eps_curr_year = eps_info[6].text.to_f
                    eps_last_year = eps_info[7].text.to_f
                    eps_last_2_year = eps_info[8].text.to_f
                    
                end
            else
                eps_curr_year = eps_last_year = eps_last_2_year = 0

            end
        else
            eps_curr_year = eps_last_year = eps_last_2_year = 0
        end
            
        if eps_curr_year ==  0
            eps_score = "N/A"
        elsif eps_curr_year > eps_last_year and eps_last_year > eps_last_2_year
            eps_score = "Pass"
        else 
            eps_score = "Fail"
        end
        {eps_curr_year: eps_curr_year, eps_last_year: eps_last_year, eps_last_2_year: eps_last_2_year, eps_score: eps_score}
        
    end
    
    def update
        values = get_price.merge(get_rev).merge(get_eps)
        update_attributes(values)
    end
    
end
