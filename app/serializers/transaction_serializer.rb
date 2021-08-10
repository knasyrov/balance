# frozen_string_literal: true

class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :direction, :name, :created_at, :before_balance, :after_balance

  def created_at
    object.created_at.to_s(:db)
  end
end
