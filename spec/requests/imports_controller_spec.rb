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

      expect(response.status).to eq(302)
    end

    context 'when it has invalid attributes' do
      let(:attrs) { attributes_for(:import).merge({ file: fixture_file_upload('invalid_contact_sample_import.csv') }) }

      it 'does not import and create the error log' do
        expect do
          post imports_path, params: { import: attrs }
          perform_enqueued_jobs
        end.to change { Import.count }.by(1).and change { Contact.count }.by(0)

        import = Import.last

        expect(import.logs).to eq([
          "Error importing \"E$$pecial Characters Contact,1993-01-01,(+57) 320 432 05 09,Not empty,4444333322221111,email@gmail.com\" row: Name is invalid"
        ])
      end
    end
  end
end
