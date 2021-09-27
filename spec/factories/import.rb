# frozen_string_literal: true

FactoryBot.define do
  factory :import do
    status { Import::ON_HOLD }
    name_column_number { 1 }
    birthdate_column_number { 2 }
    phone_column_number { 3 }
    address_column_number { 4 }
    credit_card_column_number { 5 }
    franchise_column_number { 6 }
    email_column_number { 7 }
    has_headers { true }
  end
end
