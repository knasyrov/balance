# frozen_string_literal: true

module WineBouncer
  class OAuth2 < Grape::Middleware::Base
    # sharing the given token with the endpoints even if they aren't protected with 'oauth2' helper
    def before
      set_auth_strategy(WineBouncer.configuration.auth_strategy)
      auth_strategy.api_context = context
      # extend the context with auth methods.
      context.extend(WineBouncer::AuthMethods)
      context.protected_endpoint = endpoint_protected?
      self.doorkeeper_request = env # set request for later use.
      doorkeeper_authorize!(*auth_scopes) if context.protected_endpoint?
      context.doorkeeper_access_token = doorkeeper_token
    end
  end
end
