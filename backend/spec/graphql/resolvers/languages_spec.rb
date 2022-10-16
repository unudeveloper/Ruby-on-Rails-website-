require 'rails_helper'

describe Resolvers::Languages, type: :request do
  let(:email) { 'user@test.com' }
  let(:password) { 'unbreakable' }
  let(:user) { create(:user, password: password, email: email) }
  let!(:jwt_token) { generate_jwt_test_token(user) }
  let(:login_email) { user.email }
  let(:login_password) { 'unbreakable' }
  let(:find_all) do
    <<~GQL
      query {
        languages {
          name
        }
      }
    GQL
  end
  let(:find_by_name) do
    <<~GQL
      query {
        languages(name: "#{query_string}") {
          id
          name
        }
      }
    GQL
  end

  let!(:in_flames) { create(:language, account: user.account, name: 'In Flames') }
  let!(:in_vain) { create(:language, account: user.account, name: 'In Vain') }
  let!(:power_quest) { create(:language, account: user.account, name: 'Power Quest') }

  describe 'languages' do
    before do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
    end

    subject { parse_graphql_response(response.body)['languages'] }

    context 'a generic query' do
      let(:query) { find_all }

      it { is_expected.to include 'name' => 'Power Quest' }
    end

    context 'a query with name' do
      let(:query) { find_by_name }
      let(:query_string) { 'In' }

      it { is_expected.to include 'name' => in_flames.name, 'id' => in_flames.uuid }
      it { is_expected.to include 'name' => in_vain.name, 'id' => in_vain.uuid }
      it { is_expected.to_not include 'name' => power_quest.name, 'id' => power_quest.uuid }
    end
  end
end
