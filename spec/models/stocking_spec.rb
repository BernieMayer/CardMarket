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

  describe "get_available_card" do
    let!(:card) { Card.new(suit: "heart", card: "7" ) }

    before {
      card.save!
      card.stocking.rental_status = Stocking::AVAILABLE    
    } 
    subject { Stocking.get_available_card }
    
    it { should be_an_instance_of Card }
    
    describe "all cards rented" do
      before do
        Stocking.all.each do |stocking|
          stocking.update(rental_status: Stocking::RENTED)
        end
      end

      it { is_expected.to be_nil }

    end
  end
end
