unless Rails.env.production?
  ENV['SEGMENT_WRITE_KEY']="c7xqante7s"
end

AnalyticsRuby = Segment::Analytics.new(
  write_key: ENV["SEGMENT_WRITE_KEY"] || "",
  on_error: Proc.new { |status, message| puts message }
)
