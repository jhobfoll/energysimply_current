# This file contains descriptions of all your stripe plans

require "stripe"
Stripe.api_key = "sk_test_BQokikJOvBiI2HlWgH4olfQ2"

Stripe::Plan.create(
  :amount => 199,
  :interval => 'month',
  :name => 'Basic Plan',
  :currency => 'usd',
  :id => 'basic_plan',
  :trial_period_days => 30
)

Stripe::Plan.create(
  :amount => 399,
  :interval => 'month',
  :name => 'Gold Plan',
  :currency => 'usd',
  :id => 'gold_plan',
  :trial_period_days => 30
)

# Example
# Stripe::Plans::PRIMO #=> 'primo'

# Stripe.plan :primo do |plan|
#
#   # plan name as it will appear on credit card statements
#   plan.name = 'Acme as a service PRIMO'
#
#   # amount in cents. This is 6.99
#   plan.amount = 699
#
#   # interval must be either 'week', 'month' or 'year'
#   plan.interval = 'month'
#
#   # only bill once every three months (default 1)
#   plan.interval_count = 3
#
#   # number of days before charging customer's card (default 0)
#   plan.trial_period_days = 30
# end

# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.
