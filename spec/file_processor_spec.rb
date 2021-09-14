require 'spec_helper'

RSpec.describe FileProcessor do
  before do
    Application.reseed
  end

  subject { described_class.call(file) }

  context 'matching' do
    context 'file: success_add_child.txt' do
      let(:file) { 'success_add_child.txt' }
      # -------------------------------------
      # ADD_CHILD Flora Minerva Female
      # -------------------------------------

      it 'returns an array of results' do
        expect(subject).to eq ['CHILD_ADDED']
      end

      it 'saves the correct person info' do
        subject
        child  = Application.find_by_name('Minerva')
        mother = Application.find_by_name('Flora')

        expect(child.mother).to eq mother
        expect(child.father).to eq mother.spouse
        expect(child.gender).to eq 'Female'
      end

      it 'adds one person to database' do
        expect { subject }.to change { Application.database.count }.by(1)
      end
    end

    context 'file: success_get_relationship.txt' do
      let(:file) { 'success_get_relationship.txt' }
      # -------------------------------------
      # GET_RELATIONSHIP Remus Maternal-Aunt
      # -------------------------------------

      it 'returns an array of results' do
        expect(subject).to eq ['Dominique']
      end
    end

    context 'file: success_get_relationship_2.txt' do
      let(:file) { 'success_get_relationship_2.txt' }
      # -------------------------------------
      # GET_RELATIONSHIP Lily Sister-In-Law
      # -------------------------------------

      it 'returns an array of results' do
        expect(subject).to eq ['Alice Darcy']
      end
    end

    context 'file: success_add_child_get_relationship.txt' do
      let(:file) { 'success_add_child_get_relationship.txt' }
      # -------------------------------------
      # ADD_CHILD Flora Minerva Female
      # GET_RELATIONSHIP Remus Maternal-Aunt
      # GET_RELATIONSHIP Minerva Siblings
      # -------------------------------------

      it 'returns an array of results' do
        expect(subject).to eq [
          'CHILD_ADDED',
          'Dominique Minerva',
          'Dominique Louis Victoire'
        ]
      end
    end
  end

  context 'non-matching' do
    context 'file: fail_add_child_get_relationship.txt' do
      let(:file) { 'fail_add_child_get_relationship.txt' }
      # -------------------------------------
      # ADD_CHILD Luna Lola Female
      # GET_RELATIONSHIP Luna Maternal-Aunt
      # -------------------------------------

      it 'returns an array of results' do
        expect(subject).to eq [
          'PERSON_NOT_FOUND',
          'PERSON_NOT_FOUND'
        ]
      end
    end

    context 'file: fail_add_child_get_relationship_2.txt' do
      let(:file) { 'fail_add_child_get_relationship_2.txt' }
      # -------------------------------------
      # ADD_CHILD Ted Bella Female
      # GET_RELATIONSHIP Remus Siblings
      # -------------------------------------

      it 'returns an array of results' do
        expect(subject).to eq [
          'CHILD_ADDITION_FAILED',
          'NONE'
        ]
      end
    end
  end
end

