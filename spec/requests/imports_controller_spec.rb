# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportsController do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:attrs) { attributes_for(:import).merge({ file: fixture_file_upload('contact_sample_import.csv') }) }

    before do
      sign_in user
      ActiveJob::Base.queue_adapter = :test
    end

    it 'creates the import record' do

      expect do
        post imports_path, params: { import: attrs }
        perform_enqueued_jobs
      end.to change { Import.count }.by(1).and change { Contact.count }.by(1)

      contact = Contact.last
      import = Import.last

      expect(import.status).to eq(Import::TERMINATED)
      expect(contact.credit_card).to eq('1111')
      expect(response.status).to eq(302)
    end

    context 'when it has invalid attributes' do
      let(:attrs) { attributes_for(:import).merge({ file: fixture_file_upload('invalid_contact_sample_import.csv') }) }
      let!(:existing_contact) { create(:contact, email: 'user@example.com', user: user) }

      it 'does not import and create the error log' do
        expect do
          post imports_path, params: { import: attrs }
          perform_enqueued_jobs
        end.to change { Import.count }.by(1).and change { Contact.count }.by(0)

        import = Import.last

        expect(import.status).to eq(Import::FAILED)

        expect(import.logs).to contain_exactly(
          "Error importing \"E$$pecial Characters Contact,1993-01-01,(+57) 320 432 05 09,Not empty,4444333322221111,email@gmail.com\" row: Validation failed: Name is invalid",
          "Error importing \"Invalid Birthdate Contact,12/1/2020,(+57) 320 432 05 09,Not empty,4444333322221111,email@gmail.com\" row: Validation failed: Date is invalid",
          "Error importing \"Invalid phone Contact,1993-01-01,(+57) 320 432 0509,Not empty,4444333322221111,email@gmail.com\" row: Validation failed: Phone is invalid",
          "Error importing \"invalid credit card,1993-01-01,(+57) 320 432 05 09,Not empty,123,email@gmail.com\" row: Validation failed: Card number is invalid",
          "Error importing \"Invalid email contact,1993-01-01,(+57) 320 432 05 09,Not empty,4444333322221111,email\" row: Validation failed: Email is invalid",
          "Error importing \"Duplicated email contact,1993-01-01,(+57) 320 432 05 09,Not empty,4444333322221111,user@example.com\" row: Validation failed: Email has already been taken"
        )
      end
    end
  end
end
