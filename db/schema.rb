# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170226182208) do

  create_table "stocks", force: :cascade do |t|
    t.text     "name"
    t.float    "price"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "rev_curr_year",            limit: 8
    t.integer  "rev_last_year",            limit: 8
    t.integer  "rev_last_2_year",          limit: 8
    t.float    "eps_curr_year"
    t.float    "eps_last_year"
    t.float    "eps_last_2_year"
    t.string   "dividends"
    t.float    "roe_curr_year"
    t.float    "roe_last_year"
    t.float    "roe_last_2_year"
    t.string   "analyst_rec"
    t.float    "surprises_curr_quarter"
    t.float    "surprises_last_quarter"
    t.float    "surprises_last_2_quarter"
    t.float    "earnings_growth"
    t.float    "short_interest"
    t.integer  "insider_trading",          limit: 8
    t.string   "rev_score"
    t.string   "eps_score"
    t.string   "roe_score"
    t.string   "analyst_rec_score"
    t.string   "surprises_score"
    t.string   "earnings_growth_score"
    t.string   "short_interest_score"
    t.string   "insider_trading_score"
    t.integer  "pass_count"
    t.integer  "fail_count"
    t.float    "forecast_year_0"
    t.float    "forecast_year_1"
    t.float    "forecast_year_2"
    t.float    "forecast_year_3"
    t.string   "forecast_score"
  end

end
