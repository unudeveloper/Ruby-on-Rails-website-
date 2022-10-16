# frozen_string_literal: true

FactoryBot.define do
  factory :tax do
    account
    name { Faker::Science.element }
    percentage { (rand * 100).round(2) }
    amount { 0 }
    start_at { DateTime.current.beginning_of_year }
    minimum_quantity { 0 }
    minimum_price { 0 }
    active { true }

    factory :tax_with_amount do
      percentage { 0 }
      amount { (rand * 1000).round(2) }
    end
  end
end
