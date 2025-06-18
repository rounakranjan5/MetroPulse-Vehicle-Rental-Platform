class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.string :status
      t.references :booking, null: false, foreign_key: true
      t.date :payment_date

      t.timestamps
    end
  end
end
