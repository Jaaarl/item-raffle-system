module AdminHelper
  def member_total_deposit(email)
    total_deposit = User.where(parent_id: email)
    total_deposit = total_deposit.map(&:total_deposit).compact
    total_deposit.sum
  end

  def total_used_coins(deposit, coins)
    deposit ||= 0
    coins ||= 0
    total_deposit = (deposit - coins)
  end
end