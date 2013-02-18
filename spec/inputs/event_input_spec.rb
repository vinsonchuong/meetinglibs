require 'spec_helper'

describe EventInput do
  subject { EventInput.new(params) }
  let(:valid_params) { {name: 'Event', archived: false} }

  context 'with valid parameters' do
    let(:params) { valid_params }
    it { should be_valid }
    its(:name) { should eq('Event') }
    its(:archived) { should be_false }
    its(:attributes) { should eq(name: 'Event', archived: false) }
  end

  context 'without name' do
    let(:params) { valid_params.except(:name) }
    it { should_not be_valid }
  end

  context 'without "archived"' do
    let(:params) { valid_params.except(:archived) }
    it { should be_valid }
    its(:archived) { should be_false }
  end
end

