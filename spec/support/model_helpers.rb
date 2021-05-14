module ModelHelper
  def generate_questions(number)
    number.times do
      create(:question)
    end
  end
end
