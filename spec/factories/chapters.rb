# frozen_string_literal: true

FactoryBot.define do
  factory :chapter do
    course
    name { Faker::Educator.course_name }
    sequence(:sequence)

    trait :with_unit do
      after(:create) do |chapter|
        create(:unit, chapter: chapter)
      end
    end
  end
end
