# frozen_string_literal: true

require 'rails_helper'

describe Attachments::Persistence do
  let(:account) { create(:account) }
  let(:parent) { create(:product, account: account) }
  let(:title) { 'Behemoth' }
  let(:params) { { title: title, parent_id: parent.uuid, parent_type: 'products' } }
  let(:attachment_persistence) { described_class.new(account) }

  describe '.create' do
    it { expect { attachment_persistence.create(params) }.to change { Attachment.count }.by(1) }
  end

  describe '.destroy' do
    let!(:attachment) { parent.attachments.create(title: title) }

    it { expect { attachment_persistence.destroy(attachment) }.to change { Attachment.count }.by(-1) }
  end
end
