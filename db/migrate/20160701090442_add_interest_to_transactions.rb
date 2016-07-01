class AddInterestToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :interest, :decimal, default: 0
  end
end
