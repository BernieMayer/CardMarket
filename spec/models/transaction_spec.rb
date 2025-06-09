require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "validations" do
    it "is valid" do
      transaction = Transaction.new(transaction_type: "rent", amount: 0.08 )

      expect(transaction).to be_valid
    end

    it "is not valid" do
      invalid_transaction = Transaction.new(transaction_type: "refund", amount: 0.08)

      expect(invalid_transaction).not_to be_valid
    end
  end
end
