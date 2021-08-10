# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user

  scope :from_date, ->(date) { where('created_at >= ?', date) }
  scope :to_date, ->(date) { where('created_at <= ?', date) }
  scope :by_period, ->(from, to) { where(created_at: (from..to)) }

  enum direction: %i[income expense]

  validates :user, :amount, presence: true

  validate :check_balance

  def self.filtered(params = {})
    if params['from'].present? && params['to'].present?
      by_period(params['from'], params['to'])
    elsif params['from'].present?
      from_date(params['from'])
    elsif params['to'].present?
      to_date(params['to'])
    else
      all
    end
  end

  private

  def check_balance
    return if income?

    errors.add(:base, 'Insufficient funds on the balance sheet') if user.balance < amount
  end
end
