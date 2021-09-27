FactoryBot.define do
  factory :contact do
    user { nil }
    name { "MyString" }
    date_of_birth { "2021-09-26" }
    phone { "(+57) 320 432 05 09" }
    address { "MyString" }
    credit_card { "MyString" }
    email { "MyString" }
  end
end
