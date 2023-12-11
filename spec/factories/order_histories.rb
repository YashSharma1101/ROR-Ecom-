FactoryBot.define do
  factory :order_history do
    user { nil }
    total_price { 1.5 }
    status { "MyString" }
  end
end
