# frozen_string_literal: true

class ChapterPrinter < Blueprinter::Base
  identifier :id
  fields :course_id
  fields :name
  fields :sequence

  view :with_units do
    association :units, blueprint: UnitPrinter
  end
end
