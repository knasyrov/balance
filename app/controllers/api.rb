# frozen_string_literal: true

class Api < Grape::API
  mount Api::Admin
  mount Api::V1

  route :any, '*path' do
    error!({ error: 'Not found' }, 404)
  end
end
