# frozen_string_literal: true

class Chapter < ApplicationRecord
  belongs_to :course
  has_many :units, dependent: :destroy
  accepts_nested_attributes_for :units, allow_destroy: true
end
