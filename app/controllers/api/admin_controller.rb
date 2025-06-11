class Api::AdminController < ApplicationController

  def stock
    render json: {available_cards: Stocking.all.available_cards.length,
    rented_cards: Stocking.all.rented_cards.length,
    lost_cards: Stocking.all.lost_cards.length }
  end

  def finances
    
  end

end
