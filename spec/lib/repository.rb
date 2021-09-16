require 'spec_helper'

RSpec.describe Repository do
  let(:model) { Person }

  let(:name) { "Raymond" }
  let(:gender) { "Male" }
  let(:params) do
    {
      name: name,
      gender: gender
    }
  end

  before do
    Repository.clear!
  end

  describe '.create' do
    subject { model.create(params) }

    it 'store the columns' do
      expect(subject.name).to eq name
      expect(subject.gender).to eq gender
    end
  end

  describe '.count' do
    subject { model.create(params) }

    it 'increments count' do
      expect { subject }.to change { model.count }.by(1)
    end
  end

  describe '.find' do
    let(:first_row_id) { 1 }
    before do
      model.create(params)
    end

    subject { model.find(first_row_id) }

    it 'can find by id' do
      expect(subject).to be_truthy
      expect(subject.name).to eq name
      expect(subject.gender).to eq gender
    end
  end
end

