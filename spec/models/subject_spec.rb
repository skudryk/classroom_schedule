require 'spec_helper'

RSpec.describe Subject, type: :model do
  describe 'validations' do
    before do
      subject = Subject.new(
        name: 'Introduction to Programming',
        code: 'CS101',
        description: 'Basic programming concepts',
        credits: 3
      )
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'requires a name' do
      subject.update(name: nil)
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it 'requires a code' do
      subject.update(code: nil)
      expect(subject).not_to be_valid
      expect(subject.errors[:code]).to include("can't be blank")
    end

    it 'requires credits' do
      subject.update(credits: nil)
      expect(subject).not_to be_valid
      expect(subject.errors[:credits]).to include("can't be blank")
    end

    it 'requires unique code' do
      duplicate = Subject.new(**subject.attributes)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:code]).to include('has already been taken')
    end

    it 'requires credits to be greater than 0' do
      subject = Subject.new(name: 'Programming', code: 'CS101', credits: 0)
      expect(subject).not_to be_valid
      expect(subject.errors[:credits]).to include('must be greater than 0')

      subject.credits = -1
      expect(subject).not_to be_valid
      expect(subject.errors[:credits]).to include('must be greater than 0')
    end
  end

end
