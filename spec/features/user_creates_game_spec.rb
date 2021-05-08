require 'rails_helper'

RSpec.feature 'Authenticated user creates a game', type: :feature do
  given(:user) { create :user }

  given!(:questions) do
    (0..14).to_a.map do |i|
      create(
        :question, level: i,
        text: "Когда была куликовская битва номер #{i}?",
        answer1: '1380', answer2: '1381', answer3: '1382', answer4: '1383'
      )
    end
  end

  background { login_as(user) }

  scenario 'successfully' do
    visit '/'
    click_link 'Новая игра'

    expect(page).to have_content 'Когда была куликовская битва номер 0?'
    expect(page).to have_content '1380'
    expect(page).to have_content '1381'
    expect(page).to have_content '1382'
    expect(page).to have_content '1383'
  end
end
