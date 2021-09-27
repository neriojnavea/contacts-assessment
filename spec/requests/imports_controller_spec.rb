# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportsController do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:attrs) { attributes_for(:import).merge({ file: fixture_file_upload('contact_sample_import.csv') }) }

    before do
      ActiveJob::Base.queue_adapter = :test
    end

    it 'creates the import record' do
      sign_in user

      expect do
        post imports_path, params: { import: attrs }
        perform_enqueued_jobs
      end.to change { Import.count }.by(1).and change { Contact.count }.by(1)

      expect(response.status).to eq(302)
    end
  end
end
