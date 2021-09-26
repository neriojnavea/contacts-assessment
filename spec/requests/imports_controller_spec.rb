# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    login_user

    before do
      ActiveJob::Base.queue_adapter = :test
    end

    it 'creates the import record' do
      attrs = attributes_for(:import)

      expect do
        post :index, params: { import: attrs }
      end.to change { Import.count }.by(1)

      expect(response.status).to eq(200)
    end
  end
end
