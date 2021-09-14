require 'spec_helper'

RSpec.describe Person do
  let(:male) { 'Male' }
  let(:female) { 'Female' }

  let(:name) { nil }
  let(:gender) { nil }
  let(:father) { nil }
  let(:mother) { nil }
  let(:spouse) { nil }

  let(:person_name) { 'Adam' }
  let(:person_gender) { male }
  let(:person_father) { nil }
  let(:person_mother) { nil }
  let(:person_spouse) { nil }

  let(:person_params) do
    {
      name: person_name,
      gender: person_gender,
      father: person_father,
      mother: person_mother,
      spouse: person_spouse
    }
  end

  let(:subject_params) do
    {
      name: name,
      gender: gender,
      father: father,
      mother: mother,
      spouse: spouse
    }
  end

  describe '#valid?' do
    let(:person) { described_class.new(person_params) }
    subject { described_class.new(subject_params).valid? }

    context 'invalid' do
      context 'with no name and gender' do
        it 'is invalid' do
          expect(subject).to eq false
        end
      end

      context 'with gender' do
        let(:gender) { male }

        it 'is invalid' do
          expect(subject).to eq false
        end
      end

      context 'with name' do
        let(:name) { 'Peter' }

        it 'is invalid' do
          expect(subject).to eq false
        end
      end

      context 'with name and gender' do
        let(:name) { 'Peter' }
        let(:gender) { male }

        context 'when father is present but not Person' do
          let(:father) { 'just-a-string' }

          it 'is invalid' do
            expect(subject).to eq false
          end
        end

        context 'when mother is present but not Person' do
          let(:mother) { 'just-a-string' }

          it 'is invalid' do
            expect(subject).to eq false
          end
        end

        context 'when spouse is present but not Person' do
          let(:spouse) { 'just-a-string' }

          it 'is invalid' do
            expect(subject).to eq false
          end
        end
      end
    end

    context 'valid' do
      context 'with name and gender' do
        let(:name) { 'Peter' }
        let(:gender) { male }

        it 'is valid' do
          expect(subject).to eq true
        end

        context 'when father is a Person' do
          let(:person_name) { 'Papa' }
          let(:father) { person }

          it 'is valid' do
            expect(subject).to eq true
          end
        end

        context 'when mother is a Person' do
          let(:person_name) { 'Mama' }
          let(:mother) { person }

          it 'is valid' do
            expect(subject).to eq true
          end
        end

        context 'when spouse is a Person' do
          let(:person_name) { 'Darling' }
          let(:spouse) { person }

          it 'is valid' do
            expect(subject).to eq true
          end
        end
      end
    end
  end

  describe '#save' do
    let(:name) { 'Peter' }
    let(:gender) { male }
    let(:person) do
      described_class.new(name: name,
                          gender: gender,
                          father: father,
                          mother: mother,
                          spouse: spouse)
    end

    subject { person.save }

    it 'adds to the data store' do
      expect { subject }.to change { Application.database.count }.by(1)
    end
  end
end

