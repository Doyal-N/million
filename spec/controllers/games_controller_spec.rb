require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:game) { create(:game_with_questions, user: user) }
  let(:game2) { create(:game_with_questions, user: other_user) }

  context 'when authenticated user' do
    before { login(user) }

    describe 'GET #show' do
      context 'when user tries show own game' do
        before { get :show, params: { id: user.games.find(game.id) } }

        it 'assigns game_question' do
          expect(assigns(:game_question)).to eq(game.current_game_question)
        end

        it 'render template show' do
          expect(response).to render_template :show
        end
      end

      context 'when other user' do
        it "don't show stranger game" do
          get :show, params: { id: game2 }

          expect(response.status).to eq(302)
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'POST #create' do
      context 'when this is first game' do
        it "creates game" do
          generate_questions(15)

          post :create
          new_game = assigns(:game)

          expect(response).to redirect_to new_game
          expect(new_game.user).to eq(user)
        end
      end

      context 'when this is second game' do
        it "can't creates double game" do
          game
          one_more_game = assigns(:game)

          expect { post :create }.to change(Game, :count).by(0)
          expect(response).to redirect_to game_path(game)
          expect(one_more_game).to be_nil
        end
      end
    end

    describe 'PUT #take_money' do
      it 'redirects to user, changes status and finishes game' do
        put :take_money, params: { id: game }

        expect(response).to redirect_to user_path(user)
        expect(assigns(:game).status).to eq(:money)
        expect(assigns(:game).finished?).to be_truthy
      end
    end

    describe 'PUT #answer' do
      context 'when user answered correctly' do
        it 'continues game and redirects to game' do
          question = game.current_game_question

          put :answer, params: { id: game, letter: question.correct_answer_key }

          expect(response).to redirect_to game_path(game)
          expect(game.finished?).to be_falsey
        end
      end

      context 'when user answered wrong' do
        it 'finishes game and redirect to user' do
          put :answer, params: { id: game, letter: 'a' }

          expect(response).to redirect_to user_path(user)
          expect(assigns(:game).finished?).to be_truthy
        end
      end
    end
  end

  context 'when anonimous user' do
    describe 'GET #show' do
      it 'can not show game and redirects to login' do
        get :show, params: { id: game }

        expect(response.status).not_to eq(200)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST #create' do
      it 'can not create game and redirects to login' do
        post :create

        expect(response.status).not_to eq(200)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PUT #take_money' do
      it 'can not take money and redirects to login' do
        put :take_money, params: { id: game }

        expect(response.status).not_to eq(200)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PUT #answer' do
      it 'can not give answer and redirects to login' do
        put :answer, params: { id: game }

        expect(response.status).not_to eq(200)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PUT #help' do
      it 'can not get help and redirects to login' do
        put :help, params: { id: game }

        expect(response.status).not_to eq(200)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
