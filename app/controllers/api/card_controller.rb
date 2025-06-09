class Api::CardController < ApplicationController

  def index 
    @card = Card::first
    render json: { suit: @card.suit, card: @card.card }
  end
  
end
