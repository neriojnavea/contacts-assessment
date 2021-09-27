# frozen_string_literal: true

class ImportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @import = Import.new(
      name_column_number: 1,
      birthdate_column_number: 2,
      phone_column_number: 3,
      address_column_number: 4,
      credit_card_column_number: 5,
      email_column_number: 6
    )

    @imports = current_user.imports
  end

  def create
    @import = current_user.imports.new(import_params)

    if @import.save
      ProcessContactImportJob.perform_later(@import.id)
    else
      flash[:danger] = @import.errors.full_messages.join(', ') unless @import.save
    end

    redirect_to imports_path
  end

  def show
    @import = current_user.imports.find(params[:id])
  end

  private

  def import_params
    params
      .require(:import)
      .permit(%i[
                name_column_number
                birthdate_column_number
                phone_column_number
                address_column_number
                credit_card_column_number
                franchise_column_number
                email_column_number
                file
                has_headers?
              ])
  end
end
