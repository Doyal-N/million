FactoryBot.define do
  factory :user do
    name { 'Rob' }
    is_admin { false }
    balance { 0 }
    sequence(:email) { |n| "text#{n}@mail.ru" }

    after(:build) { |u| u.password_confirmation = u.password = "123456"}
  end
end
