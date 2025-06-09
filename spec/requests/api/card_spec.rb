require 'rails_helper'

RSpec.describe "Api::Cards", type: :request do
  describe "GET /index" do

    let!(:card1) { Card.create!(suit: 'spade', card: '3') }
    
    it "should return a successful response" do
      get "/api/card"
      expect(response).to have_http_status(:ok)
    end

    it "should contain the correct json fields" do
        get "/api/card"
        json = JSON.parse(response.body)

        expect(json).to include("suit", "card")
    end
  end
end
