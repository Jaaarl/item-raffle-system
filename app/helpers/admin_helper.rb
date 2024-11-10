module AdminHelper
  def member_total_deposit(email)
    total_deposit = User.where(parent_id: email)
    total_deposit = total_deposit.map(&:total_deposit).compact
    total_deposit.sum
  end
end