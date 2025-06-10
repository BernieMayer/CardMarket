class Stocking < ApplicationRecord
  belongs_to :card
  AVAILABLE = "available"
  RENTED = "rented"
  LOST = "lost"
  RENTAL_STATUS = [AVAILABLE, RENTED, LOST]

  validates :rental_status, inclusion: { in: RENTAL_STATUS }

  scope :available_cards, -> { where(rental_status: AVAILABLE)}

  def rent 
    self.update(rental_status: RENTED, time_rented_out: Time.now)
    #pretend to charge Paypal account
  end

  def self.get_available_card
    stocked_cards = Stocking.all.available_cards
    picked_stocking = stocked_cards.sample
    
    return nil if picked_stocking.nil?

    picked_stocking.rent
    picked_stocking.card
  end
end
