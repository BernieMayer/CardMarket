class Api::CardController < ApplicationController

  before_action :reject_banned_users

  def index 
    @card = Stocking.get_available_card(user_id: params[:user_id])
    render json: { suit: @card&.suit, card: @card&.card }
  end

  def update
    begin
      @card = Card.find_by(suit: params[:suit], card: params[:card])
      @card.stocking.return_card
    rescue CardAlreadyReturnedError
      render json: { errors: "Card can't be returned" }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound
      render json: {error: "Card not found"}, status: not_found
    else
      # pretend to charge Paypal account
      render json: { suit: @card&.suit, card: @card&.card }
    end
  end

  def reject_banned_users
    if SystemState.instance.check_if_user_is_banned(params[:user_id])
      render json: { error: "User is banned" }, status: :forbidden
    end
  end
end
