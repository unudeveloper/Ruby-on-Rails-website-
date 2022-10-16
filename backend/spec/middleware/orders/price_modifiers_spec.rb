# frozen_string_literal: true

require 'rails_helper'

describe Orders::PriceModifiers do
  let(:account) { create(:account) }
  let(:order) { create(:order, account: account) }
  let(:user) { order.user }
  let!(:tax) { create(:tax, account: account) }
  let!(:discount) { create(:discount_for_user, account: account, user: user) }
  let!(:coupon) { create(:coupon, account: account) }
  let(:order_modifiers) { described_class.new(order) }

  describe '#add' do
    subject { order_modifiers.add }

    it { is_expected.to include tax }
    it { is_expected.to include discount }
  end
end
