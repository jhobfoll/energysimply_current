json.array!(@tdus) do |tdu|
  json.extract! tdu, :id, :name, :apt_avg, :apt_best, :house_avg, :house_best
  json.url tdu_url(tdu, format: :json)
end
