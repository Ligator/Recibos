class CreateUserTransactions < ActiveRecord::Migration
  def change
    create_table :user_transactions do |t|
      t.references :transaction
      t.references :users

      t.timestamps null: false
    end
  end
end
