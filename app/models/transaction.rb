class Transaction < ApplicationRecord
  RENT = "rent"
  CARD_REPLACEMENT = "card_replacement"
  TRANSACTION_TYPE = [RENT, CARD_REPLACEMENT]

  validates :transaction_type , inclusion: { in: TRANSACTION_TYPE }
  
end
