FactoryGirl.define do
  factory :tagged_item do
    entity_identifier { SecureRandom.uuid }
    entity_type       { Faker::Lorem.word }
  end
end
