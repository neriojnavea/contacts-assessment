# frozen_string_literal: true
require 'csv'

class ProcessContactImportJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    import = Import.find(import_id)

    import.update!(status: Import::PROCESSING)

    CSV.parse(import.file.download).each_with_index do |row, index|
      next if index == 0 && import.has_headers?

      create_contact(row, import)
    end
  end

  def create_contact(row, import)
    Contact.create!(
      name: row[import.name_column_number - 1],
      date_of_birth: row[import.birthdate_column_number - 1],
      phone: row[import.phone_column_number - 1],
      address: row[import.address_column_number - 1],
      credit_card: row[import.credit_card_column_number - 1],
      franchise: '', #TODO: this comes from credit card
      email: row[import.email_column_number - 1],
      user: import.user
    )
  rescue ActiveRecord::RecordInvalid
    import.logs << "Error importing \"#{row.join(',')}\" row: Name is invalid"
    import.save!
  end
end
