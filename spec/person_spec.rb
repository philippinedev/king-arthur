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

  before do
    Repository.clear!
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

  describe 'add one to database' do
    let(:name) { 'Peter' }
    let(:gender) { male }

    describe '#save' do
      let(:person) do
        described_class.new(name: name,
                            gender: gender,
                            father: father,
                            mother: mother,
                            spouse: spouse)
      end

      subject { person.save }

      it 'adds to the data store' do
        expect { subject }.to change { Person.count }.by(1)
      end
    end

    describe '.create' do
      subject {
        described_class.create(name: name,
                               gender: gender,
                               father: father,
                               mother: mother,
                               spouse: spouse)
      }

      it 'adds to the data store' do
        expect { subject }.to change { Person.count }.by(1)
      end
    end
  end

  describe 'creating a spouse' do
    let(:husband) { described_class.create(name: "Husbando", gender: "Male") }

    subject { described_class.create(name: "Wifey", gender: "Female", spouse: husband) }

    it "will automatically update the spouse's spouse as well" do
      expect { subject }.to change { husband.spouse }
    end
  end

  context 'with parents' do
    let!(:father) { described_class.create(name: "Fathero", gender: "Male") }
    let!(:mother) { described_class.create(name: "Mothery", gender: "Female", spouse: father) }

    describe '#relatives_with_relation - sons' do
      let(:relationship) { 'Son' }
      let!(:son1)   { described_class.create(name: "Boy1", gender: "Male", father: father, mother: mother) }
      let!(:son2)   { described_class.create(name: "Boy2", gender: "Male", father: father, mother: mother) }
      let!(:daughter) { described_class.create(name: "Girly", gender: "Female", father: father, mother: mother) }
      let(:sons) { [son1, son2] }

      subject { parent.relatives_with_relation(relationship) }

      context 'when father is parent' do
        let(:parent) { father }

        it "knows the father's sons" do
          expect(subject).to eq sons
        end
      end

      context 'when mother is parent' do
        let(:parent) { mother }

        it "knows the mother's sons" do
          expect(subject).to eq sons
        end
      end
    end

    describe '#relatives_with_relation - daughters' do
      let(:relationship) { 'Daughter' }
      let!(:daughter1) { described_class.create(name: "Girly1", gender: "Female", father: father, mother: mother) }
      let!(:daughter2) { described_class.create(name: "Girly2", gender: "Female", father: father, mother: mother) }
      let!(:son)   { described_class.create(name: "Boy", gender: "Male", father: father, mother: mother) }
      let(:daughters) { [daughter1, daughter2] }

      subject { parent.relatives_with_relation(relationship) }

      context 'when father is parent' do
        let(:parent) { father }

        it "knows the father's daughters" do
          expect(subject).to eq daughters
        end
      end

      context 'when mother is parent' do
        let(:parent) { mother }

        it "knows the mother's daughters" do
          expect(subject).to eq daughters
        end
      end
    end

    describe '#relatives_with_relation - siblings' do
      let(:relationship) { 'Siblings' }
      let!(:daughter1) { described_class.create(name: "Girly1", gender: "Female", father: father, mother: mother) }
      let!(:daughter2) { described_class.create(name: "Girly2", gender: "Female", father: father, mother: mother) }
      let!(:son)   { described_class.create(name: "Boy", gender: "Male", father: father, mother: mother) }
      let(:siblings) { [daughter2, son] }

      subject { daughter1.relatives_with_relation(relationship) }

      it 'will return siblings' do
        expect(subject).to eq siblings
      end
    end
  end
end

