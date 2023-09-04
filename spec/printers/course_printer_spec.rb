# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursePrinter, type: :printer do
  subject(:render_hash) { described_class.render_as_hash(course) }

  let(:course) { FactoryBot.create(:course) }

  describe 'fields' do
    it { is_expected.to include(id: course.id) }
    it { is_expected.to include(name: course.name) }
    it { is_expected.to include(lecturer: course.lecturer) }
    it { is_expected.to include(description: course.description) }
  end

  context 'when called with view :with_chapters_and_units' do
    subject(:render_hash) { described_class.render_as_hash(course, view: :with_chapters_and_units) }

    let!(:chapter) { FactoryBot.create(:chapter, :with_unit, course: course) }

    it { is_expected.to include(chapters: [ChapterPrinter.render_as_hash(chapter, view: :with_units)]) }
  end
end
