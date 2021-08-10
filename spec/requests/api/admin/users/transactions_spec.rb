# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Admin::Users::Transactions', type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:employee) { create(:user) }
  let!(:token) { create(:access_token, resource_owner_id: admin.id) }

  before do
    controller.stub(:doorkeeper_token) { token }
  end

  describe 'GET #index' do
    let!(:list) { create_list(:transaction, 3, user: employee) }
    let!(:old_transaction) { create(:transaction, user: employee, created_at: Date.today - 5.days) }
    let!(:future_transaction) { create(:transaction, user: employee, created_at: Date.today + 5.days) }

    before do
      get "/api/admin/users/#{employee.id}/transactions", params: {
        format: :json,
        access_token: token.token
      }
    end
    it 'return transactions' do
      expect(JSON.parse(response.body)['data'].count).to eq(5)
    end

    describe 'summary' do
      let!(:attrs) { attributes_for(:transaction) }

      before do
        employee.movement! attrs

        get "/api/admin/users/#{employee.id}/transactions", params: {
          format: :json,
          access_token: token.token
        }
      end

      it 'return summary' do
        rsp = JSON.parse(response.body)
        expect(rsp['summary']['end_balance']).to eq(attrs[:amount])
      end
    end

    describe 'filtered' do
      before do
        get "/api/admin/users/#{employee.id}/transactions", params: {
          format: :json,
          access_token: token.token,
          from: (Date.today - 1.day).to_s(:db),
          to: (Date.today + 1.day).to_s(:db)
        }
      end

      it 'return summary' do
        expect(JSON.parse(response.body)['data'].count).to eq(3)
      end
    end
  end

  describe 'POST #create' do
    describe 'when the amount exceeds the user balance when debiting' do
      let!(:attrs) { attributes_for(:transaction, amount: 1000, direction: :expense) }

      before do
        post "/api/admin/users/#{employee.id}/transactions", params: {
          format: :json,
          access_token: token.token
        }.merge(attrs)
      end

      it 'return error' do
        expect(JSON.parse(response.body)['message']).not_to be_empty
      end

      it 'return error status' do
        expect(response.status).to eq(400)
      end
    end
  end
end
