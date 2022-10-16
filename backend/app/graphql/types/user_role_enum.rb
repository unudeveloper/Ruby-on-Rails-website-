# frozen_string_literal: true

module Types
  class UserRoleEnum < Types::BaseEnum
    value 'User', value: 'user'
    value 'Admin', value: 'admin'
    value 'Manager', value: 'manager'
  end
end
