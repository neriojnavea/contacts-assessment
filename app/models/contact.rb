class Contact < ApplicationRecord
  validates :name, format: { without: /[!@#$%^&*()_+{}\[\]:;'"\/\\?><.,]/ }

  belongs_to :user
end
