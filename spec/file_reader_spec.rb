require 'spec_helper'

RSpec.describe FileReader do
  let(:file) { "missing.txt" }
  let(:input_file) { test_file(file) }

  subject { FileReader.readlines(input_file) }

  context 'when file does not exist' do
    it 'will raise error' do
      expect { subject }.to raise_error Errno::ENOENT
    end
  end

  context 'when file exists' do
    let(:file) { "success_add_child_get_relationship.txt" }

    it 'can read a file into array' do
      expect(subject[0]).to eq "ADD_CHILD Flora Minerva Female"
      expect(subject[1]).to eq "GET_RELATIONSHIP Remus Maternal-Aunt"
      expect(subject[2]).to eq "GET_RELATIONSHIP Minerva Siblings"
    end
  end
end

