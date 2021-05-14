require 'rails_helper'

RSpec.feature 'Viewing user profile', type: :feature do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:game1) { create(:game, user: user, prize: 5000,
    current_level: 5, fifty_fifty_used: true, finished_at: Time.now + 10.minutes) }

  scenario 'Unauthorized person view profile' do
    visit user_path(user)

    expect(page).to have_content(user.name)
    expect(page).to have_content(game1.current_level)
    expect(page).to have_content(I18n.l(game1.created_at, format: :short))
    expect(page).to have_content(number_to_currency(game1.prize))
    expect(page).to_not have_link('Сменить имя и пароль')
  end

  scenario 'User view strange profile' do
    login_as(other_user)

    visit user_path(user)

    expect(page).to have_content(user.name)
    expect(page).to have_content(game1.current_level)
    expect(page).to have_content(I18n.l(game1.created_at, format: :short))
    expect(page).to have_content(number_to_currency(game1.prize))
    expect(page).to have_content('50/50')
    expect(page).to_not have_link('Сменить имя и пароль')
  end
end
