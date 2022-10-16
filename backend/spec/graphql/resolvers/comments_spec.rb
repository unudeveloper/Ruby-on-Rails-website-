# frozen_string_literal: true

require 'rails_helper'

describe Resolvers::Comments, type: :request do
  let(:email) { 'user@test.com' }
  let(:password) { 'unbreakable' }
  let(:manager) { create(:manager, password: password, email: email) }
  let!(:jwt_token) { generate_jwt_test_token(manager) }
  let(:login_email) { manager.email }
  let(:login_password) { 'unbreakable' }
  let(:user) { create(:user, account: manager.account) }
  let(:find_all) do
    <<~GQL
      query {
        comments {
          id
          description
          approved
          user {
            id
            name
          }
        }
      }
    GQL
  end
  let(:find_approved) do
    <<~GQL
      query {
        comments(approved: #{query_string}) {
          id
          approved
        }
      }
    GQL
  end

  let!(:comment1) { create(:comment, account: user.account, approved: true) }
  let!(:comment2) { create(:comment, account: user.account, approved: true) }
  let!(:comment3) { create(:comment, account: user.account, approved: false) }

  describe 'comments' do
    before do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
    end

    subject { parse_graphql_response(response.body)['comments'] }

    context 'a generic query' do
      let(:query) { find_all }

      it { is_expected.to match(array_including(a_hash_including('description' => comment1.description))) }
    end

    context 'a query filtered by approved' do
      let(:query) { find_approved }
      let(:query_string) { true }

      it { is_expected.to match(array_including(a_hash_including('id' => comment1.uuid))) }
      it { is_expected.to match(array_including(a_hash_including('id' => comment2.uuid))) }
      it { is_expected.to_not match(array_including(a_hash_including('id' => comment3.uuid))) }
    end
  end
end
