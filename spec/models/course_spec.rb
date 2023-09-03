# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course do
  describe '.available' do
    before do
      FactoryBot.create(:course, available: true)
      FactoryBot.create(:course, available: false)
    end

    it 'returns only courses with available: true' do
      expect(described_class.available.count).to eq(1)
    end
  end
end
