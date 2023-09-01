# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitPrinter, type: :printer do
  subject(:render_hash) { described_class.render_as_hash(unit) }

  let(:unit) { FactoryBot.create(:unit) }

  describe 'fields' do
    it { is_expected.to include(id: unit.id) }
    it { is_expected.to include(chapter_id: unit.chapter_id) }
    it { is_expected.to include(name: unit.name) }
    it { is_expected.to include(description: unit.description) }
    it { is_expected.to include(content: unit.content) }
    it { is_expected.to include(sequence: unit.sequence) }
  end
end
