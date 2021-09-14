require 'spec_helper'

RSpec.describe GetRelationshipTransformer do
  let(:row_input) { nil }

  subject { described_class.call(row_input) }

  it 'returns nil' do
    expect(subject).to eq nil
  end

  describe 'GET_RELATIONSHIP' do
    context 'when not valid' do
      let(:row_input) { 'GET_RELATIONSHIP' }

      it 'returns nil' do
        expect(subject).to eq nil
      end

      context 'when less than three params' do
        let(:row_input) { 'GET_RELATIONSHIP Remus' }

        it 'returns nil' do
          expect(subject).to eq nil
        end
      end

      context 'when more than three params' do
        let(:row_input) { 'GET_RELATIONSHIP Remus Maternal-Aunt Abc' }

        it 'returns nil' do
          expect(subject).to eq nil
        end
      end

      context 'when invalid relationship' do
        let(:row_input) { 'GET_RELATIONSHIP Remus Potato' }

        it 'returns nil' do
          expect(subject).to eq nil
        end
      end
    end

    context 'when valid' do
      let(:command) { 'GET_RELATIONSHIP' }
      let(:person) { 'Remus' }
      let(:relationship) { 'Maternal-Aunt' }

      let(:row_input) { "#{command} #{person} #{relationship}" }
      let(:expected) do
        {
          command: command,
          person: person,
          relationship: relationship
        }
      end

      context 'when female' do
        it 'accepts three params only' do
          expect(subject).to eq expected
        end
      end

      context 'when male' do
        let(:gender) { 'Male' }

        it 'accepts three params only' do
          expect(subject).to eq expected
        end
      end
    end
  end
end
