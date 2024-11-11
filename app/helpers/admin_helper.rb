module AdminHelper
  def total_used_coins(deposit, coins)
    deposit ||= 0
    coins ||= 0
    total_deposit = (deposit - coins)
  end
end