# frozen_string_literal: true

class UnitPrinter < Blueprinter::Base
  identifier :id
  fields :chapter_id
  fields :name
  fields :description
  fields :content
  fields :sequence
end
