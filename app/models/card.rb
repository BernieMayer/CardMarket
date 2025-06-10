class Card < ApplicationRecord
  has_one :stocking
  SUITS = ["spade", "heart", "club", "diamond"]
  CARDS = ["A", "2", "3", "4", "5", "6", "7", "8",  "9", "10", "11", "12", "13"]

  validates :suit, inclusion: { in: SUITS }, allow_nil: true
  validates :card, inclusion: { in: CARDS << "joker"}

  after_create :create_stocking

  def create_stocking
    build_stocking(rental_status: Stocking::AVAILABLE).save!
  end
  
end
