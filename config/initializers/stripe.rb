unless Rails.env.production?
  ENV['STRIPE_PUBLIC_KEY']="pk_test_72yGCQY2UJdbZWpUEyXVqgH9"
  ENV['STRIPE_SECRET_KEY']="sk_test_LtokYQwTH0eDyl11GwXwXpWH"
end