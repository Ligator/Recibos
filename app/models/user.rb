class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :inflows,  :class_name => 'Transaction', :foreign_key => 'payee_id'
  has_many :outflows, :class_name => 'UserTransaction', :foreign_key => 'user_id'
  # has_many :inflows,  :class_name => 'Transaction', :foreign_key => 'payee_id'
  # has_many :outflows, :class_name => 'Transaction', :foreign_key => 'payer_id'

  def find_transactions
    transactions = Transaction.where("payer_id = ? or payee_id = ?", self.id, self.id).reverse
    transactions.map do |transaction|
      receive_money = transaction.payee_id == self.id
      interested_id = receive_money ? transaction.payer_id : transaction.payee_id
      interested_user = User.select([:id, :email]).find(interested_id) rescue nil
      total_payed = transaction.payments.where("done_date IS NOT NULL").pluck(:amount).sum
      total_debit = transaction.payments.pluck(:amount).sum
      @advance_percentage = total_debit != 0 ? ((total_payed / total_debit) * 100) : 0
      {object: transaction, receive_money: receive_money, interested: interested_user, status: transaction.state?, percentage: @advance_percentage}
    end
  end
end
