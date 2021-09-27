class Contact < ApplicationRecord
  validates :name, presence: true, format: { without: /[!@#$%^&*()_+{}\[\]:;'"\/\\?><.,]/ }
  validates :phone, presence: true, format: { with: /(\(\+\d{1,2}\)\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{2}[\s.-]\d{2}/ }
  validates :address, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :user_id }

  belongs_to :user
end
