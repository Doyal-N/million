FactoryBot.define do
  factory :user do
    name { 'Rob' }
    sequence(:email) { |n| "text#{n}@mail.ru" }
    is_admin { false }
    balance { 0 }

    after(:build) { |u| u.password_confirmation = u.password = "123456"}
  end
end
