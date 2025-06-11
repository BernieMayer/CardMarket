require 'singleton'

class SystemState 
  include Singleton

  def initialize
    @banned_users = Set.new
  end

  def ban_user(user_id)
    @banned_users.add(user_id.to_i)
  end

  def check_if_user_is_banned(user_id)
    @banned_users.include?(user_id.to_i)
  end
end