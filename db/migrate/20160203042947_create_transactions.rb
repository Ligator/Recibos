class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.date :date
      t.decimal :amount
      t.text :description
      t.string :image
      t.integer :payer_id
      t.integer :payee_id

      t.timestamps
    end
  end
end
