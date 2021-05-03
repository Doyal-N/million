require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) { create(:user) }
  let(:game_w_questions) { create(:game_with_questions, user: user) }
  let(:game_timeout) { create(:game_with_questions, user: user, created_at: Time.now - 36.minutes) }
  let(:game_finished) { create(:game_with_questions, user: user, is_failed: true, finished_at: Time.now + 1.day) }

  describe 'Game Factory' do
    it 'Game.create_game! new correct game' do
      generate_questions(60)
      game = nil

      expect { game = described_class.create_game_for_user!(user) }.to change(described_class, :count).by(1)
        .and(change(GameQuestion, :count).by(15))
      expect(game.user).to eq(user)
      expect(game.status).to eq(:in_progress)
      expect(game.game_questions.size).to eq(15)
      expect(game.game_questions.map(&:level)).to eq (0..14).to_a
    end
  end

  describe 'game mechanics' do
    it 'answer correct continues game' do
      level = game_w_questions.current_level
      q = game_w_questions.current_game_question

      expect(game_w_questions.status).to eq(:in_progress)

      game_w_questions.answer_current_question!(q.correct_answer_key)

      expect(game_w_questions.current_level).to eq(level + 1)
      expect(game_w_questions.current_game_question).not_to eq(q)
      expect(game_w_questions.status).to eq(:in_progress)
      expect(game_w_questions.finished?).to be_falsey
    end
  end

  describe 'take_money!' do
    context 'when return' do
      it 'time over' do
        game_timeout.take_money!

        expect(game_timeout.status).to eq(:timeout)
        expect(game_timeout.prize).to eq 0
        expect(user.balance).to eq 0
      end

      it 'game finished' do
        game_finished.take_money!

        expect(game_finished.status).to eq(:timeout)
        expect(game_finished.prize).to eq 0
        expect(user.balance).to eq 0
      end
    end

    context 'when take money' do
      it 'user take money' do
        question = game_w_questions.current_game_question
        game_w_questions.answer_current_question!(question.correct_answer_key)

        game_w_questions.take_money!

        expect(game_w_questions.prize).to be > 0
        expect(game_w_questions.status).to eq :money
        expect(game_w_questions.finished?).to be_truthy
        expect(user.balance).to eq game_w_questions.prize
      end
    end
  end

  describe 'status' do
    it ':in_progress' do
      expect(game_w_questions.status).to eq(:in_progress)
    end

    context 'when failed' do
      it ':timeout' do
        expect(game_finished.status).to eq(:timeout)
      end

      it ':fail' do
        game_w_questions.finished_at = Time.now
        game_w_questions.is_failed = true

        expect(game_w_questions.status).to eq(:fail)
      end
    end

    context 'when not failed' do
      before { game_w_questions.finished_at = Time.now }

      it ':won' do
        game_w_questions.current_level = 15
        expect(game_w_questions.status).to eq(:won)
      end

      it ':money' do
        expect(game_w_questions.status).to eq(:money)
      end
    end
  end

  describe 'current_game_question' do
    let(:game) { create(:game_with_questions, user: user, current_level: 7) }

    it 'return needed question' do
      question = game_w_questions.current_game_question
      question2 = game.current_game_question

      expect(question.level).to eq(0)
      expect(question2.level).to eq(7)
    end
  end

  describe 'previous_level' do
    let(:game1) { create(:game, current_level: 5) }
    let(:game2) { create(:game, current_level: 13) }

    it 'return previous level' do
      expect(game1.previous_level).to eq(4)
      expect(game2.previous_level).to eq(12)
    end
  end
end
