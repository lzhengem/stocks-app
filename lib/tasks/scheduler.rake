
desc "This task is called by the Heroku scheduler add-on"

task :update_stocks_A => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'A'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        puts "updating #{ticker}"
        new_stock.update
        puts "finish updating #{ticker}"
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_B => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'B'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_C => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'C'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_D => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'D'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_E => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'E'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_F => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'F'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_G => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'G'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_H => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'H'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_I => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'I'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_J => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'J'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_K => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'K'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_L => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'L'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_M => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'M'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_N => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'N'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_O => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'O'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_P => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'P'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_Q => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'Q'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_R => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'R'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_S => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'S'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_T => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'T'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_U => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'U'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_V => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'V'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_W => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'W'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_X => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'X'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_Y => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'Y'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

task :update_stocks_Z => :environment do
    # require File.expand_path("../../../app/helpers/application_helper.rb", __FILE__)
    include ApplicationHelper
    letter = 'Z'
    puts "starting update_stocks_#{letter}"
    tickers = tickers_for_letter letter
  
    tickers.each_with_index do |ticker, index|
        puts "working on #{ticker}, index #{index}"
        if stock = Stock.find_by(name: ticker.downcase)
            stock.destroy
        end
        new_stock = Stock.new(name: ticker.downcase)
        new_stock.update
    end
    puts "end update_stocks_#{letter}"
end

