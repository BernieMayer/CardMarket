class Stocking < ApplicationRecord
  belongs_to :card
  RENTAL_STATUS = ["available", "rented", "lost"]

  validates :rental_status, inclusion: { in: RENTAL_STATUS }
end
