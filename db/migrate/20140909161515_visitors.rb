class Visitors < ActiveRecord::Migration
  def change
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

     t.timestamps

   end
  end
end


