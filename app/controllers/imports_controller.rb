class ImportsController < ApplicationController
	before_action :authenticate_user!

	def index
		@import = Import.new(
			name_column_number: 1,
      birthdate_column_number: 2,
      phone_column_number: 3,
      address_column_number: 4,
      credit_card_column_number: 5,
      franchise_column_number: 6,
      email_column_number: 7
		)
		@imports = Import.all
	end

	def create
		@import = Import.new(import_params.merge(user: current_user))

		flash[:danger] = @import.errors.full_messages.join(', ') unless @import.save

		redirect_to imports_path
	end

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
			])
	end
end