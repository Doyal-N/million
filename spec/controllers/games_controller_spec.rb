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

    it 'assigns game_question' do
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
      get :show, params: { id: game }

      expect(response.status).to eq(302)
      expect(response).to redirect_to(user_session_path)
    end
  end

  describe 'PUT #take_money' do
    it 'redirect_to user' do
      login(user)
      put :take_money, params: { id: game }

      expect(response).to redirect_to user_path(user)
      expect(flash[:warning]).to be
    end
  end

  describe 'double game' do
    it "user can't to create second game" do
      login(user)
      game

      expect { post :create }.to change(Game, :count).by(0)
      expect(response).to redirect_to game_path(game)
      expect(flash[:alert]).to be
    end
  end
end
