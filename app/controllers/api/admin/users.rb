# frozen_string_literal: true

class ::Api::Admin::Users < ::Api::Admin
  resource :users do
    desc 'Users list'
    get root: false do
      User.all
    end

    desc 'Get user'
    oauth2
    get ':id', root: false, serializer: ::UserSerializer do
      User.find(params[:id])
    end

    desc 'Create user'
    oauth2
    params do
      requires :email, type: String
      requires :password, type: String
      optional :role, type: String, values: User.roles.keys
    end
    post root: false do
      attrs = declared(params, include_missing: false).to_h
      User.create!(attrs)
    end
  end
end
