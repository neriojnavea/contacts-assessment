class ContactsController < ApplicationController
	before_action :authenticate_user!

	def index
		@contacts = current_user.contacts.paginate(page: params[:page])
	end
end