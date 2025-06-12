class Api::AdminController < ApplicationController

  def stock
    render json: {available_cards: Stocking.all.available_cards.length,
    rented_cards: Stocking.all.rented_cards.length,
    lost_cards: Stocking.all.lost_cards.length }
  end

  def finances

    recent_transactions = Transaction.where(created_at: 3.hours.ago..Time.now)

    mapped_transactions = recent_transactions.map{ |transaction|{
      type: transaction.transaction_type, 
     amount: transaction.amount, created_at:
      transaction.created_at}}

    render json: {
      balance: SystemState.instance.balance,
      pending_rent: Stocking.pending_rent,
      pending_replacemnt: Stocking.pending_replacemnt,
      recent_transactions: mapped_transactions
    }
    
  end

end
