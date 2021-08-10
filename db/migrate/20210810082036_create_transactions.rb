# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :user
      t.integer :direction
      t.string :name
      t.decimal :amount, precision: 8, scale: 2
      t.decimal :before_balance, precision: 8, scale: 2
      t.decimal :after_balance, precision: 8, scale: 2
      t.timestamps
    end
  end
end
