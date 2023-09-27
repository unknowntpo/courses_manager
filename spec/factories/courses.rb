require 'faker'

FactoryBot.define do
  factory :course do
    name { Faker::Book.name }
    lecturer { Faker::Name.name }
    description { Faker::Lorem.word }
    # add other default attributes here as needed
  end
end

