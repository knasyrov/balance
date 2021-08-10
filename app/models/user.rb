# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :transactions

  enum role: %i[admin employee]

  def movement!(params)
    User.transaction do
      t = transactions.build(params)
      t.before_balance = balance
      t.after_balance = t.income? ? balance + t.amount : balance - t.amount
      t.save!
      update_attribute!(:balance, t.after_balance)
      t
    end
  end
end
