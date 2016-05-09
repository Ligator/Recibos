class AddConfirmPayeeConfirmPayerSeenByPayerSeenByPayeeToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :confirm_payee, :boolean, default: false
    add_column :transactions, :confirm_payer, :boolean, default: false
    add_column :transactions, :seen_by_payer, :boolean, default: false
    add_column :transactions, :seen_by_payee, :boolean, default: false
  end
end
