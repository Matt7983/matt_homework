# frozen_string_literal: true

class CoursePrinter < Blueprinter::Base
  identifier :id
  fields :name
  fields :lecturer
  fields :description

  view :with_chapters_and_units do
    association :chapters, blueprint: ChapterPrinter, view: :with_units do |course|
      course.chapters.order(:sequence)
    end
  end
end
