require 'singleton'

class SystemState 
  include Singleton

  def initialize
    @banned_users = Set.new
    @balance = 5.0
  end

  def add_to_balance(amount)
    @balance += amount
  end

  def charge_balance(amount)
    @balance -= amount
  end

  def ban_user(user_id)
    @banned_users.add(user_id.to_i)
  end

  def check_if_user_is_banned(user_id)
    @banned_users.include?(user_id.to_i)
  end
end