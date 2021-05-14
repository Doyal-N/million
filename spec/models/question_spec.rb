require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_presence_of(:level) }
    it { is_expected.to validate_inclusion_of(:level).in_range(0..14) }

    context 'uniq validation' do
      let!(:question) { create(:question) }

      it { is_expected.to validate_uniqueness_of(:text) }
    end
  end
end
