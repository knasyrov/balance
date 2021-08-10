# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user+#{n}@example.com" }
    password { 'qwerty' }

    trait :admin do
      role { 'admin' }
    end
  end
end
