require 'rails_helper'

RSpec.describe GameQuestion, type: :model do
  let(:game_question) { create(:game_question, a: 2, b: 1, c: 4, d: 3) }
  let(:question) { create(:game_question) }

  describe 'game status' do
    it 'correct .variants' do
      expect(game_question.variants).to eq(
        'a' => game_question.question.answer2,
        'b' => game_question.question.answer1,
        'c' => game_question.question.answer4,
        'd' => game_question.question.answer3
      )
    end

    it 'correct .answer_correct?' do
      expect(game_question).to be_answer_correct('b')
    end
  end

  describe 'delegate methods' do
    it { is_expected.to delegate_method(:text).to(:question) }
    it { is_expected.to delegate_method(:level).to(:question) }
  end

  describe 'correct_answer_key' do
    it 'correct answer' do
      expect(game_question.correct_answer_key).to eq('b')
      expect(question.correct_answer_key).to eq('d')
    end

    it 'incorrect answer' do
      expect(question.correct_answer_key).not_to eq('c')
      expect(game_question.correct_answer_key).not_to eq('a')
    end
  end
end
