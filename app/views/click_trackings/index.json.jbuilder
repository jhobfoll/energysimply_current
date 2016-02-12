json.array!(@click_trackings) do |click_tracking|
  json.extract! click_tracking, :id, :zip, :url, :user_id
  json.url click_tracking_url(click_tracking, format: :json)
end
