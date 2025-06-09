class Api::CardController < ApplicationController

  def index 

    # TODO: Implement full logic of renting cards
    @card = Card::first
    render json: { suit: @card.suit, card: @card.card }
  end
  
end
