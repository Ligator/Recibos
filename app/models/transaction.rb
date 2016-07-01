class Transaction < ActiveRecord::Base
	belongs_to :payee, :class_name => 'User', :foreign_key => 'payee_id'
	belongs_to :payer, :class_name => 'User', :foreign_key => 'payer_id'
	has_many :payments, dependent: :destroy

	validates_presence_of :amount

	def state?
      if confirm_payee and confirm_payer
        status = "Terminado"
      elsif confirm_payee == !confirm_payer
        status = "Esperando confirmación"
      elsif seen_by_payee == !seen_by_payer
        status = "Visto"
      else
        status = ""
      end
	end
end
