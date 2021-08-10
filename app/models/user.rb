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

  def movement! params
    User.transaction do
      t = transactions.build(params)
      #if t.valid?
        t.before_balance = balance
        t.after_balance = t.income? ? balance + t.amount : balance - t.amount
        t.save!
        balance = t.after_balance
        update_attribute!(:balance, t.after_balance)
        t
      #else
      ##  puts '@@@@@@@@', t.errors.full_messages
      #  raise t.errors.full_messages
      #end
    end
  end
end
