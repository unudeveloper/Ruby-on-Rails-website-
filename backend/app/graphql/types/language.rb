# frozen_string_literal: true

module Types
  class Language < Types::BaseObject
    field :id, String, null: false, method: :uuid
    field :name, String, null: false
    field :code, String, null: false
    field :description, String, null: true
  end
end
