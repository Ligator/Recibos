class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :inflows,  :class_name => 'Transaction', :foreign_key => 'payee_id'
  has_many :outflows, :class_name => 'Transaction', :foreign_key => 'payer_id'

  def find_transactions
    transactions = Transaction.where("payer_id = ? or payee_id = ?", self.id, self.id).reverse
    transactions.map do |transaction|
      receive_money = transaction.payee_id == self.id
      interested_id = receive_money ? transaction.payer_id : transaction.payee_id
      interested_user = User.select([:id, :email]).find(interested_id) rescue nil
      if transaction.confirm_payee and transaction.confirm_payer
        status = "Terminado"
      elsif transaction.confirm_payee == !transaction.confirm_payer
        status = "Esperando confirmación"
      elsif transaction.seen_by_payee == !transaction.seen_by_payer
        status = "Visto"
      else
        status = ""
      end
      {object: transaction, receive_money: receive_money, interested: interested_user, status: status}
    end
  end
end
