require 'rails_helper'

RSpec.describe "Api::Cards", type: :request do
  let!(:user_id) { 514 }
  let(:mock_system_state) { instance_double(SystemState, check_if_user_is_banned: false ) }

  before do
    allow(SystemState).to receive(:instance).and_return(mock_system_state)
  end

  describe "GET /index" do

    let!(:card1) { Card.create!(suit: 'spade', card: '3') }
    
    it "should return a successful response" do
      get "/api/card", params:{user_id: user_id}
      expect(response).to have_http_status(:ok)
    end

    it "should contain the correct json fields" do
      get "/api/card", params:{user_id: user_id}
      json = JSON.parse(response.body)

      expect(json).to include("suit", "card")
    end
  end

  describe "Client who is banned tries a request" do
    let! (:banned_user_id) { 100 }

      let(:mock_system_state) { instance_double(SystemState, ban_user:  nil, check_if_user_is_banned: true ) }

      before do
        allow(SystemState).to receive(:instance).and_return(mock_system_state)
      end

    it "returns a 403 forbidden code" do
      SystemState.instance.ban_user(banned_user_id)
      
      get "/api/card", params:{ user_id: banned_user_id }

      expect(response).to have_http_status(:forbidden)
    end
  end
  

  describe "PUT" do
    let!(:card) { Card.create!(suit: 'heart', card: '5') }

    it "returns the card" do
      card.stocking.rent(user_id)

      put "/api/card", params:{ suit: card.suit, card: card.card }

      expect(response).to have_http_status(:ok)

      card.reload
      expect(card.stocking.rental_status).to eq Stocking::AVAILABLE
    end

    it "returns error for card that is available" do
      card.stocking.update(rental_status: Stocking::AVAILABLE)

      put "/api/card", params:{ suit: card.suit, card: card.card }
      
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Card can't be returned")
    end
  end
end
