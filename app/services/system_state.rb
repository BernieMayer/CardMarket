require 'singleton'

class SystemState 
  include Singleton
  attr_reader :balance

  LOST_CARD_FEE = 0.50

  def initialize
    @banned_users = Set.new
    @balance = 5.0
  end

  def add_to_balance(amount)
    @balance += amount
  end

  def charge_balance(amount)
    @balance -= amount
    if @balance < 0
      raise StandardError.new("balance can't go below 0")
    end
  end

  def ban_user(user_id)
    @banned_users.add(user_id.to_i)
  end

  def check_if_user_is_banned(user_id)
    @banned_users.include?(user_id.to_i)
  end

  def restock
    Stocking.mark_cards_as_lost
    lost_cards = Stocking.all.lost_cards
    charge_balance(lost_cards.length * LOST_CARD_FEE)

    lost_cards.each do |lost_card|
      # clear each card:
      lost_card.update(time_rented_out: nil, rental_status: Stocking::AVAILABLE)
    end

  end
end