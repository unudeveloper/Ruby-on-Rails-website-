# frozen_string_literal: true

module Types
  class Tax < Types::BaseObject
    field :id, String, null: false, method: :uuid
    field :name, String, null: false
    field :product, Types::Product, null: true
    field :category, Types::Category, null: true
    field :user, Types::User, null: true
    field :product_id, String, null: true
    field :category_id, String, null: true
    field :user_id, String, null: true
    field :active, Boolean, null: true
    field :percentage, Float, null: true
    field :amount, Integer, null: true
    field :start_at, GraphQL::Types::ISO8601DateTime, null: false
    field :end_at, GraphQL::Types::ISO8601DateTime, null: true
    field :minimum_price, Float, null: true
  end
end
