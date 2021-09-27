# frozen_string_literal: true
require 'csv'

class ProcessContactImportJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    @at_least_one_contact_created = false
    import = Import.find(import_id)
    import.update!(status: Import::PROCESSING)

    CSV.parse(import.file.download).each_with_index do |row, index|
      next if index == 0 && import.has_headers?

      create_contact(row, import)
    end

    import.update!(status: @at_least_one_contact_created ? Import::TERMINATED : Import::FAILED)
  end

  def create_contact(row, import)
    card_number =  row[import.credit_card_column_number - 1]
    card_detector = CreditCardValidations::Detector.new(card_number)

    return push_logs(import, row, "Validation failed: Card number is invalid") unless card_detector.valid?

    Contact.create!(
      name: row[import.name_column_number - 1],
      date_of_birth: parse_date(row[import.birthdate_column_number - 1]),
      phone: row[import.phone_column_number - 1],
      address: row[import.address_column_number - 1],
      credit_card: card_number.last(4),
      franchise: card_detector.brand&.capitalize, #TODO: this comes from credit card
      email: row[import.email_column_number - 1],
      user: import.user
    )
    @at_least_one_contact_created = true
  rescue ActiveRecord::RecordInvalid => e
    push_logs(import, row, e.message)
  rescue Date::Error
    push_logs(import, row, 'Validation failed: Date is invalid')
  end

  def parse_date(date)
    Date.strptime(date, '%F') 
  end

  def push_logs(import, row, error)
    import.logs << "Error importing \"#{row.join(',')}\" row: #{error}"
    import.save!
  end
end
