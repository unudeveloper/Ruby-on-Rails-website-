require 'rails_helper'

describe OrderItems::PriceModifiers do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }
  let(:order) { create(:order, account: account, user: user) }
  let(:category) { create(:category, account: account) }
  let(:product) { create(:product, account: account, category: category) }
  let(:order_item) { build(:order_item, order: order, product: product) }
  let!(:tax) { create(:tax, account: account, category: category) }
  let!(:discount) { create(:discount_for_user, account: account, product: product, user: user) }
  let(:order_item_modifiers) { described_class.new(order_item) }

  describe '#add' do
    before { order_item.save }

    subject { order_item.order_price_modifiers.pluck(:price_modifier_id) }

    it { is_expected.to include tax.id }
    it { is_expected.to include discount.id }
  end
end
