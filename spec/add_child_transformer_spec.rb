require 'spec_helper'

RSpec.describe AddChildTransformer do
  let(:row_input) { nil }

  subject { described_class.call(row_input) }

  it 'returns nil' do
    expect(subject).to eq nil
  end

  context 'when not valid command' do
    let(:row_input) { 'SING_CHILD Flora Minerva Female' }

    it 'returns nil' do
      expect(subject).to eq nil
    end
  end

  describe 'ADD_CHILD' do
    context 'when not valid' do
      let(:row_input) { 'ADD_CHILD' }

      it 'returns nil' do
        expect(subject).to eq nil
      end

      context 'when less than three params' do
        let(:row_input) { 'ADD_CHILD Flora' }

        it 'returns nil' do
          expect(subject).to eq nil
        end
      end

      context 'when more than three params' do
        let(:row_input) { 'ADD_CHILD Flora Minerva Female Abc' }

        it 'returns nil' do
          expect(subject).to eq nil
        end
      end

      context 'when gender is invalid' do
        let(:row_input) { 'ADD_CHILD Flora Minerva Fomale' }

        it 'returns nil' do
          expect(subject).to eq nil
        end
      end
    end

    context 'when valid' do
      let(:command) { 'ADD_CHILD' }
      let(:mother) { 'Flora' }
      let(:child) { 'Minerva' }
      let(:gender) { 'Female' }

      let(:row_input) { "#{command} #{mother} #{child} #{gender}" }
      let(:expected) do
        {
          command: command,
          mother: mother,
          child: child,
          male: gender == 'Male'
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
