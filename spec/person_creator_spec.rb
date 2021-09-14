require 'spec_helper'

RSpec.describe PersonCreator do
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

  let(:person) { described_class.call(person_params) }
  subject { described_class.call(subject_params) }

  context 'with name and gender' do
    let(:name) { 'Peter' }
    let(:gender) { male }

    it 'saves the correct attributes' do
      expect(subject.class).to eq Person
      expect(subject.name).to eq name
      expect(subject.gender).to eq gender
      expect(subject.father).to eq father
      expect(subject.mother).to eq mother
      expect(subject.spouse).to eq spouse
    end

    context 'when father is a Person' do
      let(:person_name) { 'Papa' }
      let(:father) { person }

      it 'saves the correct attributes' do
        expect(subject.class).to eq Person
        expect(subject.father.class).to eq Person
      end
    end

    context 'when mother is a Person' do
      let(:person_name) { 'Mama' }
      let(:mother) { person }

      it 'saves the correct attributes' do
        expect(subject.class).to eq Person
        expect(subject.mother.class).to eq Person
      end
    end

    context 'when spouse is a Person' do
      let(:person_name) { 'Darling' }
      let(:spouse) { person }

      it 'saves the correct attributes' do
        expect(subject.class).to eq Person
        expect(subject.spouse.class).to eq Person
      end
    end
  end
end

