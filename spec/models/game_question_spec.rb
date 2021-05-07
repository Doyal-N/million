require 'rails_helper'

RSpec.describe GameQuestion, type: :model do
  let(:game_question) { create(:game_question, a: 2, b: 1, c: 4, d: 3) }

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
    end
  end

  describe 'help_hash' do
    it 'return empty help_hash at start game' do
      expect(game_question.help_hash).to eq({})
    end

    it 'write data into hash and save' do
      game_question.help_hash[:key] = 'test'
      game_question.help_hash['text'] = 'body'

      expect(game_question.help_hash).to eq({ key: 'test', 'text' => 'body' })
    end
  end

  describe 'add_fifty_fifty' do
    it 'return empty hint at start game' do
      expect(game_question.help_hash).not_to include(:fifty_fifty)
    end

    it 'return correct keys after added hint' do
      game_question.add_fifty_fifty
      fifty_fifty = game_question.help_hash[:fifty_fifty]

      expect(fifty_fifty).to include(game_question.correct_answer_key)
      expect(fifty_fifty.size).to eq 2
    end
  end

  describe 'add_friend_call' do
    it 'return empty hint at start game' do
      expect(game_question.help_hash).not_to include(:friend_call)
    end

    it 'return key-hint after use' do
      game_question.add_friend_call
      friend_call = game_question.help_hash[:friend_call]

      expect(game_question.help_hash).to include(:friend_call)
      expect(friend_call).to end_with('A').or end_with('B').or end_with('C').or end_with('D')
    end
  end
end
