require 'rails_helper'

RSpec.describe "Api::Admins", type: :request do
  let(:user_id) { 123 }
 
  describe "admin/stock" do
    let!(:card1) { Card.create!(suit: "spade", card: "2") }
    let!(:card2) { Card.create!(suit: "spade", card: "5") }
    let!(:card3) { Card.create!(suit: "heart", card: "7") }

    before {
      card2.stocking.rent(user_id)
      card3.stocking.update(rental_status: Stocking::LOST)
    }

    it "should return a succesful response" do
       get "/api/admin/stock"
      expect(response).to have_http_status(:ok)
    end

    it "should return the correct json" do
      get "/api/admin/stock"
      json = JSON.parse(response.body)

      expect(json["lost_cards"]).to eq(1)
      expect(json["available_cards"]).to eq(1)
      expect(json["rented_cards"]).to eq(1)
    end
  end

  describe "admin/finances" do
    let(:mock_system_state) { instance_double(SystemState, balance: 6.20, add_to_balance: nil) }

    before do
      allow(SystemState).to receive(:instance).and_return(mock_system_state)
    end

    it "should return a succesful response" do
      get "/api/admin/finances"
      expect(response).to have_http_status(:ok)
    end

    it "should return the correct json" do
      get "/api/admin/finances"
      json = JSON.parse(response.body)

      expect(json["balance"]).to eq(6.20)
      expect(json).to include("pending_rent")
      expect(json).to include("recent_transactions")
    end
  end
end
