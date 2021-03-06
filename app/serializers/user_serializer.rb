# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :balance, :role
end
