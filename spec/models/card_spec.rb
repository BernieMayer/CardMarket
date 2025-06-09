require 'rails_helper'

RSpec.describe Card, type: :model do
  describe "validations" do
    it "is valid" do
      card = Card.new(suit: "spade", card: "4")

      expect(card).to be_valid
    end

    it "is joker" do
      joker = Card.new(suit: nil, card: "joker")

      expect(joker).to be_valid
    end

    it "is not valid" do
      invalid_card = Card.new(suit: "spade", card:"18")

      expect(invalid_card).not_to be_valid
    end
  end
end
