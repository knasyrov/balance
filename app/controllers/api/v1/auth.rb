# frozen_string_literal: true

class ::Api::V1::Auth < ::Api::Admin
  resource :auth do
    desc 'Login'
    params do
      requires :email, type: String
      requires :password, type: String
    end
    post 'login' do
      attrs = declared(params).to_h.symbolize_keys
      user = User.find_by(email: attrs[:email])

      raise 'Password is incorrect or user not found' unless user&.valid_password?(attrs[:password])

      authorize!(user)
    end

    desc 'Registration'
    params do
      requires :email, type: String
      requires :password, type: String
    end
    post 'register' do
      attrs = declared(params).to_h.symbolize_keys
      user = User.create!(attrs)
      authorize!(user)
    end

    desc 'Logout'
    oauth2
    delete 'logout' do
      doorkeeper_access_token.destroy
      status(200)
    end
  end
end
