class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :inflows,  :class_name => 'Transaction', :foreign_key => 'payee_id'
  has_many :outflows, :class_name => 'Transaction', :foreign_key => 'payer_id'
end
