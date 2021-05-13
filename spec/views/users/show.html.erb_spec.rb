require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  context 'when page visit current user' do
    before do
      current_user = assign(:user, build_stubbed(:user, name: 'Goblin'))
      allow(view).to receive(:current_user).and_return(current_user)

      render
    end

    it 'renders name' do
      expect(rendered).to match 'Goblin'
    end

    it 'renders button for change password' do
      expect(rendered).to match 'Сменить имя и пароль'
    end

    it 'renders partial game' do
      assign(:games, [build_stubbed(:game)])
      stub_template 'users/_game.html.erb' => 'Да начнется Игра'

      render
      expect(rendered).to match 'Да начнется Игра'
    end
  end

  context 'when page visit other person' do
    before do
      assign(:user, build_stubbed(:user, name: 'Goblin'))
      allow(view).to receive(:current_user).and_return(false)

      render
    end

    it 'renders name' do
      expect(rendered).to match 'Goblin'
    end

    it 'missing button for change password' do
      expect(rendered).not_to match 'Сменить имя и пароль'
    end

    it 'renders partial game' do
      assign(:games, [build_stubbed(:game)])
      stub_template 'users/_game.html.erb' => 'Да начнется Игра'

      render
      expect(rendered).to match 'Да начнется Игра'
    end
  end
end
