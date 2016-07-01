class Payment < ActiveRecord::Base
  belongs_to :debit, class_name: "Transaction"
end
