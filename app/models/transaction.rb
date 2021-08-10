# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user

  scope :from_date, ->(date) { where('created_at > ?', date) }
  scope :to_date, ->(date) { where('created_at < ?', date) }
  scope :by_period, ->(from, to) { where(created_at: (from..to)) }

  enum direction: %i[income expense]

  validates :user, :amount, presence: true

  validate :check_balance

  private

  def check_balance
    return if income?

    errors.add(:base, 'Insufficient funds on the balance sheet') if user.balance < amount
  end
end
