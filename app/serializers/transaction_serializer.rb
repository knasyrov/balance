# frozen_string_literal: true

class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :direction, :name, :created_at, :before_balance, :after_balance

  def created_at
    object.created_at.to_s(:db)
  end

  def amount
    object.amount.to_f
  end

  def before_balance
    object.before_balance.to_f
  end

  def after_balance
    object.after_balance.to_f
  end
end
