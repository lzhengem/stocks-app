module ApplicationHelper
    def get_doc_from(url)
        Nokogiri.HTML(open(URI.escape(url)))
    end
    
    # def get_score(score_nil, score_pass)
    #     if score_nil
    #         "N/A"
    #     elsif score_pass
    #         "Pass"
    #     else
    #         "Fail"
    #     end
            
    # end
    
    # def get_count(scores, value)
    #     scores.select{|score| score == value}.count #find out how many values in scores is value
        
    # end
end
