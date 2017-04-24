rev_doc = get_doc_from("http://www.nasdaq.com/symbol/#{ticker}/revenue-eps")
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
                    
                    #get dividends
                    dividends = rev_info[23].text
                    
                    if dividends.to_f.zero? #if info for the latest month is missing, instead of using totals, use previous month
                        
                        #get dividends
                        dividends = rev_info[10].text
                        
                    end
                else
                    dividends = "N/A"
                end
            else
                dividends = "N/A"
            end