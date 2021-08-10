# frozen_string_literal: true
require 'doorkeeper/grape/helpers'

class ::Api::Admin < Grape::API
  version 'admin'
  content_type :json, 'application/json'
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  default_error_formatter :json
  use ::WineBouncer::OAuth2

  rescue_from :all do |e|
    klass = e.class.to_s
    if klass.eql?('ActiveRecord::RecordInvalid')
      error!({ message: e.record.errors.full_messages.join(', ') }, 400)
    elsif klass.match('OAuthUnauthorizedError')
      error!({}, 401)
    elsif klass.match('OAuthForbiddenError')
      error!({}, 403)
    elsif klass.match('ValidationErrors')
      error!({ message: e.message }, 400)
    end
  end

  helpers do
    def current_user
      resource_owner
    end

    def admins_only
      unless current_user.admin?
        error!({ message: '401 Unauthorized' }, 401)
      end
    end
  end

  before do
    admins_only
  end

  mount ::Api::Admin::Users
  mount ::Api::Admin::Users::Transactions
end

