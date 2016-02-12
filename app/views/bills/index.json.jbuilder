json.array!(@bills) do |bill|
  json.extract! bill, :id, :svc_address_1, :svc_address_2, :current_provider, :kwh_usage, :energy_charge, :usage_charge, :esi_id, :meter_number, :account_number, :plan_end_date, :, :last_bill_amount
  json.url bill_url(bill, format: :json)
end
