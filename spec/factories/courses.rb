# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    name { Faker::Educator.course_name }
    lecturer { Faker::Name.name }
    description { Faker::Quote.yoda }
    available { 1 }

    trait :with_chapter_and_unit do
      after(:create) do |course|
        create(:chapter, :with_unit, course: course)
      end
    end
  end
end
