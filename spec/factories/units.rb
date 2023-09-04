# frozen_string_literal: true

FactoryBot.define do
  factory :unit do
    chapter
    name { Faker::Educator.course_name }
    description { Faker::Quote.famous_last_words }
    content { Faker::Quote.matz }
    sequence(:sequence)
  end
end
