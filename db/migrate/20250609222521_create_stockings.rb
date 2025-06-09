class CreateStockings < ActiveRecord::Migration[7.1]
  def change
    create_table :stockings do |t|
      t.references :card, null: false, foreign_key: true
      t.string :rental_status
      t.timestamp :time_rented_out
      t.integer :user_id_rented_to

      t.timestamps
    end
  end
end
