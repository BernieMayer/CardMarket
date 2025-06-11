class Stocking < ApplicationRecord
  belongs_to :card
  AVAILABLE = "available"
  RENTED = "rented"
  LOST = "lost"
  RENTAL_STATUS = [AVAILABLE, RENTED, LOST]

  validates :rental_status, inclusion: { in: RENTAL_STATUS }

  scope :available_cards, -> { where(rental_status: AVAILABLE)}

  def rent(user_id) 
    self.update(rental_status: RENTED,
               time_rented_out: Time.now, user_id_rented_to: user_id)
  end

  def return_card
    raise CardAlreadyReturnedError if self.rental_status != RENTED

    self.update(rental_status: AVAILABLE, time_rented_out: nil) 
  end

  def self.get_available_card(user_id:)
    stocked_cards = Stocking.all.available_cards
    picked_stocking = stocked_cards.sample
    
    return nil if picked_stocking.nil?

    picked_stocking.rent(user_id)
    picked_stocking.card
  end
end

class CardAlreadyReturnedError < StandardError
  def message
    "This card has already been returned."
  end
end
