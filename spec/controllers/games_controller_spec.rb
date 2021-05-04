require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  let(:user) { create(:user) }
  before { login(user) }

  describe 'GET #show' do
    let(:game) { create(:game_with_questions, user: user) }
    let(:current_question) { game.current_game_question }

    before { get :show, params: { id: user.games.find(game.id) } }

    it 'assigns game, game_question' do
      expect(assigns(:game)).to eq(game)
      expect(assigns(:game_question)).to eq(current_question)
    end

    it 'render show' do
      expect(response).to render_template :show
    end
  end
end
