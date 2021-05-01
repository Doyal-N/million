FactoryBot.define do
  factory :question do
    answer1 { "#{rand(4)}" }
    answer2 { "#{rand(4)}" }
    answer3 { "#{rand(4)}" }
    answer4 { "#{rand(4)}" }

    sequence(:text)  { |n| "text #{n}" }
    sequence(:level) { |n| n % 15 }
  end
end
