require 'rails_helper'

RSpec.describe Stocking, type: :model do
  describe "validations" do
    it "is valid" do
      card = Card.new(suit:"heart", card:"5")

      stocking = Stocking.new(card: card, rental_status: "available", 
                        time_rented_out: Time.now, user_id_rented_to: 0)

      expect(stocking).to be_valid
    end

    it "is invalid" do
      card = Card.new(suit:"heart", card:"5")

      stocking = Stocking.new(card: card, rental_status: "?", 
                        time_rented_out: Time.now, user_id_rented_to: 0)

      expect(stocking).not_to be_valid
    end
  end
end
