class Transaction < ApplicationRecord
  TRANSACTION_TYPE = ["rent", "card_replacement"]

  validates :transaction_type , inclusion: { in: TRANSACTION_TYPE }
  
end
