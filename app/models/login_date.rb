class LoginDate < ApplicationRecord

  def self.count_this_month(user_id)
    LoginDate.where(user_id: user_id).where('login_date >= ?', Date.today.beginning_of_month).where('login_date <= ?', Date.today.end_of_month).count
  end
end