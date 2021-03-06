class Game < ApplicationRecord
  PRIZES = [
      100, 200, 300, 500, 1000,
      2000, 4000, 8000, 16_000, 32_000,
      64_000, 125_000, 250_000, 500_000, 1_000_000
    ].freeze
  FIREPROOF_LEVELS = [4, 9, 14].freeze
  TIME_LIMIT = 35.minutes

  belongs_to :user
  has_many :game_questions, dependent: :destroy

  validates :user, presence: true
  validates :current_level, numericality: { only_integer: true }, allow_nil: false
  validates :prize,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: PRIZES.last }

  scope :in_progress, -> { where(finished_at: nil) }


  #---------  Фабрика-генератор новой игры ------------------------------

  # returns correct new game or dies with exceptions
  def self.create_game_for_user!(user)
    # внутри единой транзакции
    transaction do
      game = create!(user: user)

      # созданной игре добавляем ровно 15 новых игровых вопросов, выбирая случайный Question из базы
      Question::QUESTION_LEVELS.each do |i|
        q = Question.where(level: i).order('RANDOM()').first
        ans = [1, 2, 3, 4]
        game.game_questions.create!(question: q, a: ans.shuffle!.pop, b: ans.shuffle!.pop, c: ans.shuffle!.pop, d: ans.shuffle!.pop)
      end
      game
    end
  end

  def previous_game_question
    game_questions.find { |q| q.question.level == previous_level }
  end

  def current_game_question
    game_questions.find { |q| q.question.level == current_level }
  end

  def previous_level
    current_level - 1
  end

  # Игра закончена, если прописано поле :finished_at - время конца игры
  def finished?
    finished_at.present?
  end

  def time_out!
    return unless (Time.now - created_at) > TIME_LIMIT

    finish_game!(fire_proof_prize(previous_level), true)
    true
  end

  def answer_current_question!(letter)
    return false if time_out! || finished?

    if current_game_question.answer_correct?(letter)
      if current_level == Question::QUESTION_LEVELS.max
        finish_game!(PRIZES[Question::QUESTION_LEVELS.max], false)
      else
        save!
      end

      self.current_level += 1
      true
    else
      finish_game!(fire_proof_prize(previous_level), true)
      false
    end
  end

  def take_money!
    return if time_out! || finished?

    finish_game!(previous_level > -1 ? PRIZES[previous_level] : 0, false)
  end

  def use_help(help_type)
    help_types = %i[fifty_fifty audience_help friend_call]
    raise ArgumentError.new('wrong help_type') unless help_types.include?(help_type)

    unless self["#{help_type}_used"]
      toggle!("#{help_type}_used".to_sym)
      current_game_question.send("add_#{help_type}")
      true
    end
  end

  def status
    return :in_progress unless finished?

    if is_failed
      if (finished_at - created_at) <= TIME_LIMIT
        :fail
      else
        :timeout
      end
    elsif !is_failed && current_level > Question::QUESTION_LEVELS.max
      :won
    else
      :money
    end
  end

  private

  def finish_game!(amount = 0, failed = true)

    transaction do
      self.prize = amount
      self.finished_at = Time.now
      self.is_failed = failed
      user.balance += amount
      save!
      user.save!
    end
  end

  def fire_proof_prize(answered_level)
    lvl = FIREPROOF_LEVELS.select { |x| x <= answered_level }.last
    lvl.present? ? PRIZES[lvl] : 0
  end

end
