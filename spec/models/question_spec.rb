require 'rails_helper'

RSpec.describe Question, type: :model do

  it { is_expected.to validate_presence_of(:text) }
  it { is_expected.to validate_presence_of(:level) }
  it { is_expected.to validate_uniqueness_of(:text) }
  it { is_expected.to validate_inclusion_of(:level).in_range(0..14) }
end
