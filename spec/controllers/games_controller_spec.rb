require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  let(:user) { create(:user) }
  let(:game) { create(:game_with_questions, user: user) }

  describe 'GET #show' do
    let(:current_question) { game.current_game_question }

    before do
      login(user)
      get :show, params: { id: user.games.find(game.id) }
    end

    it 'assigns game, game_question' do
      expect(assigns(:game)).to eq(game)
      expect(assigns(:game_question)).to eq(current_question)
    end

    it 'render show' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #show stranger game' do
    let(:user2) { create(:user) }

    it 'user do not show stranger game' do
      login(:user2)
      get :show, params: { id: game.id }

      expect(response.status).to eq(302)
      expect(response).to redirect_to(user_session_path)
    end
  end
end
