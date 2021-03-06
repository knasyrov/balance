# frozen_string_literal: true

class ::Api::Admin::Users::Transactions < ::Api::Admin
  namespace 'users/:user_id' do
    resource :transactions do
      helpers do
        def resource_user
          @resource_user ||= User.find(params[:user_id])
        end
      end

      params do
        requires :user_id, type: Integer
        optional :from, type: Date
        optional :to, type: Date
      end
      desc 'Transactions list for user'
      oauth2
      get root: 'data' do
        attrs = declared(params, include_missing: false).to_h
        collection = resource_user.transactions.filtered(attrs)
        render collection, each_serializer: ::TransactionSerializer,
                           meta: {
                             start_balance: collection&.first&.before_balance&.to_f || 0.0,
                             end_balance: collection&.last&.after_balance&.to_f || 0.0
                           },
                           meta_key: :summary
      end

      params do
        requires :user_id, type: Integer
        requires :name, type: String
        requires :direction, type: String, values: Transaction.directions.keys
        requires :amount, type: BigDecimal
      end
      desc 'Create transaction'
      oauth2
      post root: false do
        attrs = declared(params, include_missing: false).to_h
        resource_user.movement!(attrs)
      end
    end
  end
end
