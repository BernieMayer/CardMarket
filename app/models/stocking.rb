class Stocking < ApplicationRecord
  belongs_to :card
  AVAILABLE = "available"
  RENTED = "rented"
  LOST = "lost"
  RENTAL_STATUS = [AVAILABLE, RENTED, LOST]

  validates :rental_status, inclusion: { in: RENTAL_STATUS }

  scope :available_cards, -> { where(rental_status: AVAILABLE)}
  scope :rented_cards, -> { where(rental_status: RENTED)}
  scope :lost_cards, -> { where(rental_status: LOST )}

  def rent(user_id) 
    self.update(rental_status: RENTED,
               time_rented_out: Time.now, user_id_rented_to: user_id)
  end

  def return_card
    raise CardAlreadyReturnedError if self.rental_status != RENTED

    if (Time.now - self.time_rented_out) < 15.minutes
      Transaction.create(transaction_type: Transaction::RENT, amount: self.calculate_rent)
      self.update(rental_status: AVAILABLE, time_rented_out: nil)
    else
      Transaction.create(transaction_type: ransaction::CARD_REPLACEMENT, amount: 0.5)
      self.update(rental_status: LOST, time_rented_out: nil)
    end
  end

  def self.mark_cards_as_lost
    self.all.where('time_rented_out < ?', 15.minutes.ago).update_all(rental_status: LOST, time_rented_out: nil)
  end

  def self.pending_rent
    self.all.rented_cards.reduce(0) { |sum, stocking| sum + stocking.calculate_rent }
  end

  def self.pending_replacemnt
    overdue_cards = self.all.where('time_rented_out < ?', 15.minutes.ago)
    overdue_cards.length * 0.50
  end

  def calculate_rent 
    diff_seconds = Time.now - time_rented_out
    diff_minutes = (diff_seconds / 60).ceil
    return diff_minutes * 0.01
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
