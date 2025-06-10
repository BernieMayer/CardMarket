class Api::CardController < ApplicationController

  def index 

    @card = Stocking.get_available_card
    render json: { suit: @card&.suit, card: @card&.card }
  end
  
end
