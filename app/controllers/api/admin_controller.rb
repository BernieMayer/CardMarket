class Api::AdminController < ApplicationController

  def stock
    render json: {available_cards: Stocking.all.available_cards.length,
    rented_cards: Stocking.all.rented_cards.length,
    lost_cards: Stocking.all.lost_cards.length }
  end

  def finances
    render json: {
      balance: SystemState.instance.balance,
      pending_rent: Stocking.pending_rent,
      pending_replacemnt: 0.0, #TODO implement logic
      recent_transactions: [] #TODO implement
    }
    
  end

end
