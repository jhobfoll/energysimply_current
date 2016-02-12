json.array!(@savings_calculator_data) do |savings_calculator_datum|
  json.extract! savings_calculator_datum, :id, :idKey, :TduCompanyName, :RepCompany, :Product, :Renewable, :TermValue, :Promo_adj, :rate_100, :rate_500, :rate_1000, :rate_2000, :rate_500_fixed, :rate_1000_fixed, :rate_2000_fixed
  json.url savings_calculator_datum_url(savings_calculator_datum, format: :json)
end
