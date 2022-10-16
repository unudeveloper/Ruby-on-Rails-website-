# frozen_string_literal: true

require 'rails_helper'

describe Carts::Consolidate do
  let(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user, total_tax: 23) }
  let!(:item_qty2) { create(:cart_item, cart: cart, quantity: 2) }
  let!(:item_qty1) { create(:cart_item, cart: cart, quantity: 1) }
  let!(:item_qty3) { create(:cart_item, cart: cart, quantity: 3) }
  let(:payment_type) { :credit_card }
  let(:amount) { cart.total }
  let(:cart_consolidate) { described_class.new(user, payment_type, amount) }

  describe '#to_order' do
    it { expect { cart_consolidate.to_order }.to change { Cart.count }.by(-1) }
    it { expect { cart_consolidate.to_order }.to change { CartItem.count }.by(-3) }
    it { expect { cart_consolidate.to_order }.to change { Order.count }.by(1) }
  end
end
