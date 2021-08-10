# frozen_string_literal: true

class ::Api::Admin < Grape::API
  version 'admin'
  content_type :json, 'application/json'
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  default_error_formatter :json
  use ::WineBouncer::OAuth2

  rescue_from :all do |e|
    klass = e.class.to_s
    case klass
    when 'ActiveRecord::RecordInvalid'
      error!({ message: e.record.errors.full_messages.join(', ') }, 400)
    when 'OAuthUnauthorizedError'
      error!({}, 401)
    when 'OAuthForbiddenError'
      error!({}, 403)
    when 'ValidationErrors'
      error!({ message: e.message }, 400)
    end
  end

  helpers do
    def current_user
      resource_owner
    end

    def admins_only
      error!({ message: '401 Unauthorized' }, 401) unless current_user.admin?
    end
  end

  before do
    admins_only
  end

  mount ::Api::Admin::Users
  mount ::Api::Admin::Users::Transactions
end
