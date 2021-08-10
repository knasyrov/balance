# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    user
    direction { 'income' }
    amount { 100.0 }
  end
end
