
desc "This task is called by the Heroku scheduler add-on"
task :update_stocks => :environment do
  # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
  include ApplicationHelper  
  puts "starting update_stocks"
  letter = 'A'
  first_doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}&pagesize=200"
  if first_doc && first_doc.css("a#two_column_main_content_lb_LastPage").any?
      last_page = first_doc.css("a#two_column_main_content_lb_LastPage").attribute('href').value.scan(/page=(\d+)/)[0][0].to_i
  else
      last_page = 1
  end
  tickers = []
  (1..last_page).each do |page|
  # (2..2).each do |page|
      doc = get_doc_from "http://www.nasdaq.com/screening/companies-by-name.aspx?letter=#{letter}&pagesize=200&page=#{page}"
      if doc
        doc.css('h3').map do |link|
            ticker = link.content.strip.upcase
            tickers << ticker
        end
      end
  end

  tickers.each_with_index do |ticker, index|
      puts "working on #{ticker}, index #{index}"
      if stock = Stock.find_by(name: ticker.downcase)
          stock.destroy
      end
      new_stock = Stock.new(name: ticker.downcase)
      new_stock.update
  end
  puts "end update_stocks"
end