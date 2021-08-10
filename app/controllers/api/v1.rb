# frozen_string_literal: true

class ::Api::V1 < Grape::API
  version 'v1'
  content_type :json, 'application/json'
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  default_error_formatter :json
  use ::WineBouncer::OAuth2

  helpers do
    def authorize! user
      token = Doorkeeper::AccessToken.create(resource_owner_id: user.id)
      Doorkeeper::OAuth::TokenResponse.new(token).body
    end
  end

  mount ::Api::V1::Auth
end
