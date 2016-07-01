class AddNamePeriodToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :name, :string
    add_column :transactions, :period, :string
  end
end
