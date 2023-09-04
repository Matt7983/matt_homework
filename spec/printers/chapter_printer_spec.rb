# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChapterPrinter, type: :printer do
  subject(:render_hash) { described_class.render_as_hash(chapter) }

  let(:chapter) { FactoryBot.create(:chapter) }

  describe 'fields' do
    it { is_expected.to include(id: chapter.id) }
    it { is_expected.to include(course_id: chapter.course_id) }
    it { is_expected.to include(name: chapter.name) }
    it { is_expected.to include(sequence: chapter.sequence) }
  end

  context 'when called with view :with_units' do
    subject(:render_hash) { described_class.render_as_hash(chapter, view: :with_units) }

    let!(:unit) { FactoryBot.create(:unit, chapter: chapter) }

    it { is_expected.to include(units: [UnitPrinter.render_as_hash(unit)]) }
  end
end
