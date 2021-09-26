# frozen_string_literal: true

class CreateImports < ActiveRecord::Migration[6.1]
  def change
    create_table :imports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'on hold'
      t.integer :name_column_number
      t.integer :birthdate_column_number
      t.integer :phone_column_number
      t.integer :address_column_number
      t.integer :credit_card_column_number
      t.integer :franchise_column_number
      t.integer :email_column_number

      t.timestamps
    end
  end
end
