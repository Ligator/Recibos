class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user_transaction, index: true, foreign_key: true
      t.datetime :programmed_date
      t.datetime :done_date
      t.decimal :amount
      t.boolean :confirm_payer
      t.boolean :confirm_payee

      t.timestamps null: false
    end
  end
end
