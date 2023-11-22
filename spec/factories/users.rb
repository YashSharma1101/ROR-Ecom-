FactoryBot.define do
  factory :user do
    email { 'abc123@gmail.com' }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
