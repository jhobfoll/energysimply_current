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

ActiveRecord::Schema.define(version: 20150309105427) do

  create_table "bills", force: true do |t|
    t.string   "svc_address_1"
    t.string   "svc_address_2"
    t.string   "current_provider"
    t.string   "kwh_usage"
    t.string   "energy_charge"
    t.string   "usage_charge"
    t.string   "esi_id"
    t.string   "meter_number"
    t.string   "account_number"
    t.string   "plan_end_date"
    t.decimal  "last_bill_amount",        precision: 8, scale: 2
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bill_image_file_name"
    t.string   "bill_image_content_type"
    t.integer  "bill_image_file_size"
    t.datetime "bill_image_updated_at"
    t.string   "bill_month"
  end

  create_table "click_trackings", force: true do |t|
    t.string   "zip"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address"
  end

  create_table "companies", force: true do |t|
    t.string   "company_name"
    t.integer  "gen_rank"
    t.integer  "ren_rank"
    t.integer  "apt_rank"
    t.integer  "house_rank"
    t.string   "p2c_rating"
    t.string   "p2c_rating_site"
    t.string   "bbb_grade"
    t.string   "bbb_grade_site"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name_ptc"
    t.string   "phone"
    t.string   "url_main"
    t.string   "tdu_name"
    t.string   "gen_plan_name"
    t.string   "ren_plan_name"
    t.string   "gen_url_enroll"
    t.string   "ren_url_enroll"
    t.string   "gen_kwh_cost_1000"
    t.string   "ren_kwh_cost_1000"
    t.integer  "yotpo_id"
    t.string   "factsheet_url"
    t.string   "gen_kwh_cost_500"
    t.string   "gen_kwh_cost_2000"
    t.string   "ren_kwh_cost_500"
    t.string   "ren_kwh_cost_2000"
    t.string   "gen_ren_percent"
    t.string   "gen_term"
    t.string   "gen_cancel_fee"
    t.string   "ren_ren_percent"
    t.string   "ren_term"
    t.string   "ren_cancel_fee"
    t.string   "ptc_url"
    t.string   "bbb_url"
    t.string   "gen_factsheet_url"
    t.string   "company_name_proper"
    t.integer  "med_house_cost_monthly"
    t.decimal  "med_house_cost_kwh"
    t.integer  "low_house_cost_monthly"
    t.decimal  "low_house_cost_kwh"
    t.integer  "high_house_cost_monthly"
    t.decimal  "high_house_cost_kwh"
    t.integer  "ren_med_house_cost_monthly"
    t.decimal  "ren_med_house_cost_kwh"
    t.integer  "ren_low_house_cost_monthly"
    t.decimal  "ren_low_house_cost_kwh"
    t.integer  "ren_high_house_cost_monthly"
    t.decimal  "ren_high_house_cost_kwh"
    t.text     "company_description"
    t.string   "logo_image"
    t.string   "postal_state"
  end

  create_table "customer_usages", force: true do |t|
    t.decimal  "mo_01",      precision: 8, scale: 2
    t.decimal  "mo_02",      precision: 8, scale: 2
    t.decimal  "mo_03",      precision: 8, scale: 2
    t.decimal  "mo_04",      precision: 8, scale: 2
    t.decimal  "mo_05",      precision: 8, scale: 2
    t.decimal  "mo_06",      precision: 8, scale: 2
    t.decimal  "mo_07",      precision: 8, scale: 2
    t.decimal  "mo_08",      precision: 8, scale: 2
    t.decimal  "mo_09",      precision: 8, scale: 2
    t.decimal  "mo_10",      precision: 8, scale: 2
    t.decimal  "mo_11",      precision: 8, scale: 2
    t.decimal  "mo_12",      precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_refs", force: true do |t|
    t.string   "email"
    t.datetime "ref_date"
    t.integer  "refd_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "savings_calculator_data", force: true do |t|
    t.integer  "idKey"
    t.string   "TduCompanyName"
    t.string   "RepCompany"
    t.string   "Product"
    t.integer  "Renewable"
    t.integer  "TermValue"
    t.decimal  "Promo_adj",       precision: 8, scale: 2
    t.decimal  "rate_100",        precision: 8, scale: 4
    t.decimal  "rate_500",        precision: 8, scale: 4
    t.decimal  "rate_1000",       precision: 8, scale: 4
    t.decimal  "rate_2000",       precision: 8, scale: 4
    t.decimal  "rate_500_fixed",  precision: 8, scale: 2
    t.decimal  "rate_1000_fixed", precision: 8, scale: 2
    t.decimal  "rate_2000_fixed", precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tdus", force: true do |t|
    t.string   "name"
    t.integer  "apt_avg"
    t.integer  "apt_best"
    t.integer  "house_avg"
    t.integer  "house_best"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.string   "trans_type"
    t.decimal  "amount",               precision: 8, scale: 2
    t.string   "payment_service"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "paypal_auth"
    t.string   "stripe_id"
    t.string   "last4"
    t.string   "brand"
    t.string   "funding"
    t.string   "exp_month"
    t.string   "exp_year"
    t.text     "stripe_callback_data"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "billing_address_1"
    t.string   "billing_address_2"
    t.string   "middle_initial"
    t.string   "maiden_name"
    t.string   "service_type"
    t.string   "plan_type"
    t.string   "dwelling_type"
    t.string   "svc_new_old"
    t.date     "move_in_date"
    t.string   "home_new_old"
    t.string   "meter_type"
    t.string   "rewired"
    t.string   "mobile"
    t.integer  "sq_ft_range"
    t.string   "dob"
    t.string   "encrypted_ssnum"
    t.integer  "payment_info_id"
    t.boolean  "admin",                  default: false
    t.string   "bill_send_method"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zip"
    t.integer  "dwolla_id"
    t.integer  "paypal_id"
    t.string   "active_payment_service"
    t.integer  "zip_id"
    t.string   "plan_grade"
    t.string   "smart_meter_auth"
    t.integer  "visitor_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "referral_key"
    t.integer  "referred_by_id"
    t.integer  "customer_usage_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "visitors", force: true do |t|
    t.string   "zip_code"
    t.integer  "zip_id"
    t.string   "postal_state"
    t.string   "plan_type"
    t.string   "plan_grade"
    t.string   "service_type"
    t.string   "dwelling_type"
    t.string   "svc_new_old"
    t.date     "move_in_date"
    t.string   "home_new_old"
    t.string   "meter_type"
    t.string   "rewired"
    t.string   "mobile"
    t.integer  "sq_ft_range"
    t.string   "sign_up_type"
    t.string   "home_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "referred_by_id"
    t.integer  "customer_usage_id"
  end

  create_table "zips", force: true do |t|
    t.string   "zip"
    t.string   "city"
    t.string   "state"
    t.string   "postal_state"
    t.string   "landing_page"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tdu_name"
    t.integer  "tdu_id"
  end

  add_index "zips", ["zip"], name: "index_zips_on_zip", unique: true

end
