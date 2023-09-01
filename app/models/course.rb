# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :chapters, dependent: :destroy
  accepts_nested_attributes_for :chapters, allow_destroy: true
end
