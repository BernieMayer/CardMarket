require 'rails_helper'

RSpec.describe Stocking, type: :model do
  let!(:user_id) { 514 }

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

  describe "return_card" do
    let!(:card) { Card.new(suit: "heart", card: "8") }
    
    before {
      card.save!
    }

    before(:each) {
      Stocking.get_available_card(user_id: user_id)
    }

    it "should update the rental status to available" do
      card.reload
      expect(card.stocking.rental_status).to eq(Stocking::RENTED)
      card.stocking.return_card

      card.reload
      expect(card.stocking.rental_status).to eq(Stocking::AVAILABLE)
    end

    describe "card has already been returned" do
      it "throws an error" do
        card.stocking.update(rental_status: Stocking::AVAILABLE)

        expect { card.stocking.return_card }.to raise_error(CardAlreadyReturnedError)
        
      end
    end
  end

  describe "get_available_card" do
    let!(:card) { Card.new(suit: "heart", card: "7" ) }

    before {
      card.save!
      card.stocking.rental_status = Stocking::AVAILABLE    
    } 
    subject { Stocking.get_available_card(user_id: user_id) }
    
    it { should be_an_instance_of Card }

    it "should show a card status of rented" do
      expect(subject.stocking.rental_status ).to eq Stocking::RENTED
    end

    it "should have a timestamp for when the card is rented" do
      freeze_time do
        expect(subject.stocking.time_rented_out).to eq Time.now
      end
    end

    it "should have the user_id for the card rented" do
      expect(subject.stocking.user_id_rented_to).to eq user_id
    end

    describe "if a card is returned afer 15 minutes" do
      it "should have a rental_status of lost" do
        card.stocking.rent(user_id)

        travel_to(Time.current + 16.minutes) do

          card.stocking.return_card

        end

        card.reload
        expect(card.stocking.rental_status).to eq(Stocking::LOST)

      end
    end
    
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
