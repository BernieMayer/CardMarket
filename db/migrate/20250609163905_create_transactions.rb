class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.decimal :amount

      t.timestamps
    end
  end
end
