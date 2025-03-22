FactoryBot.define do
  factory :session do
    token { "MyString" }
    expired_at { "MyString" }
    user { nil }
  end
end
