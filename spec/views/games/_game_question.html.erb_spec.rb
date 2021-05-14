require 'rails_helper'

RSpec.describe 'games/game_question', type: :view do
  let(:game_question) { FactoryGirl.build_stubbed :game_question }

  before do
    allow(game_question).to receive(:text).and_return('Кому на Руси жить хорошо?')
    allow(game_question).to receive(:variants).and_return(
      {'a' => 'Всем', 'b' => 'Никому', 'c' => 'Животным', 'd' => 'Людям'}
    )
  end

  # Проверяем, что шаблон выводит текст вопроса
  it 'renders question text' do
    render_partial

    expect(rendered).to match 'Кому на Руси жить хорошо?'
  end

  # Проверяем, что шаблон выводит варианты ответов
  it 'renders question text' do
    render_partial

    expect(rendered).to match 'Всем'
    expect(rendered).to match 'Никому'
    expect(rendered).to match 'Животным'
    expect(rendered).to match 'Людям'
  end

  # Проверяем, что если использована подсказка, то вариантов только два
  it 'renders half variant if fifty-fifty used' do
    allow(game_question).to receive(:help_hash).and_return({fifty_fifty: ['a', 'b']})

    render_partial

    expect(rendered).to match 'Всем'
    expect(rendered).to match 'Никому'
    expect(rendered).not_to match 'Животным'
    expect(rendered).not_to match 'Людям'
  end

  private

  # Метод, который рисует фрагмент и кладет его в rendered
  def render_partial
    render partial: 'games/game_question', object: game_question
  end
end
