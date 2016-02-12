json.array!(@customer_usages) do |customer_usage|
  json.extract! customer_usage, :id, :mo_01, :mo_02, :mo_03, :mo_04, :mo_05, :mo_06, :mo_07, :mo_08, :mo_09, :mo_10, :mo_11, :mo_12
  json.url customer_usage_url(customer_usage, format: :json)
end
