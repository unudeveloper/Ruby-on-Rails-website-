require 'rails_helper'

describe PriceModifiers::Finder do
  let(:account) { create(:account) }
  let(:category) { create(:category, account: account) }
  let(:product) { create(:product, account: account, category: category) }
  let(:order) { create(:order, account: account) }
  let(:user) { order.user }
  let(:start_at) { 3.weeks.ago }
  let(:end_at) {}

  describe '.global' do
    subject { described_class.global(order) }

    it { is_expected.to be_empty }

    context 'a generic tax' do
      let!(:tax) { create(:tax, start_at: start_at, end_at: end_at, account: account) }

      context 'when there are modifiers but dates not in range' do
        let(:end_at) { 1.week.ago }

        it { is_expected.to be_empty }
      end

      context 'when there is a global modifier available' do
        it { is_expected.to include tax }
      end
    end

    context 'discount for users' do
      let!(:discount) { create(:discount_for_user, account: account, user: user) }

      it { is_expected.to include discount }

      context 'when there is a modifier available for another user' do
        let(:user) { create(:user, account: account) }

        it { is_expected.to be_empty }
      end
    end

    context 'when there is a minumum price' do
      let(:price) { 1 }
      let!(:order_item) { create(:order_item, order: order, quantity: 40, price: price) }
      let!(:discount) { create(:discount, account: account, minimum_price: 60) }

      context 'when order price is lower' do
        it { is_expected.to be_empty }
      end

      context 'when order price is equal or higher' do
        let(:price) { 1.7 }

        it { is_expected.to include discount }
      end
    end
  end

  describe '.for_products' do
    let(:quantity) { 2 }
    let(:price) { 35.99 }
    let(:order_item) { create(:order_item, order: order, product: product, quantity: quantity, price: price) }

    subject { described_class.for_product(order_item, order_item.order) }

    context 'when there are no modifiers available' do
      it { is_expected.to be_empty }
    end

    context 'a generic tax' do
      let!(:tax) { create(:tax, start_at: start_at, end_at: end_at, account: account, product: order_item.product) }

      context 'when there are modifiers but dates not in range' do
        let(:end_at) { 1.week.ago }

        it { is_expected.to be_empty }
      end

      context 'when there is a global modifier available' do
        it { is_expected.to include tax }
      end
    end

    context 'discount for users' do
      let(:minimum_quantity) { 0 }
      let(:minimum_price) { 0 }
      let!(:discount) do
        create(
          :discount_for_user,
          user: user,
          account: account,
          category: product.category,
          minimum_quantity: minimum_quantity,
          minimum_price: minimum_price
        )
      end

      it { is_expected.to include discount }

      context 'when there is a modifier available for another user' do
        let(:user) { create(:user, account: account) }

        it { is_expected.to be_empty }
      end

      context 'when there is a minumum quantity' do
        let(:minimum_quantity) { 8 }

        context 'when order quantity is lower' do
          it { is_expected.to be_empty }
        end

        context 'when order quantity is equal or higher' do
          let(:quantity) { 10 }

          it { is_expected.to include discount }
        end
      end

      context 'when there is a minumum price' do
        let(:minimum_price) { 99.99 }

        context 'when order price is lower' do
          it { is_expected.to be_empty }
        end

        context 'when order price is equal or higher' do
          let(:quantity) { 6.6 }

          it { is_expected.to include discount }
        end
      end
    end
  end
end
