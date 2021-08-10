# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Admin::Users', type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:token) { create(:access_token, resource_owner_id: admin.id) }
  let!(:list) { create_list(:user, 2) }

  before do
    controller.stub(:doorkeeper_token) { token }
  end

  describe 'GET #index' do
    before do
      get '/api/admin/users', params: {
        format: :json,
        access_token: token.token
      }
    end
    it 'return users' do
      expect(JSON.parse(response.body).count).to eq(3) # list + admin
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }

    before do
      get "/api/admin/users/#{user.id}", params: {
        format: :json,
        access_token: token.token
      }
    end

    it 'returns not empty object' do
      expect(JSON.parse(response.body)).not_to be_empty
    end
  end
end
