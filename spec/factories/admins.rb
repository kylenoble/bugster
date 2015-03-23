FactoryGirl.define do
  factory :admin do
    email "test@ignitemedia.com"
    password "12345678"
    admin_secret ENV["ADMIN_SECRET"]
  end

end
