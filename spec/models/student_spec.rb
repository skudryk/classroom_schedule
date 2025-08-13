require 'spec_helper'

RSpec.describe Student, type: :model do
  let(:student) { Student.create!(name: 'John Doe', email: 'john@student.edu', major: 'CS', year: 2) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      student = Student.new(
        name: 'John Doe',
        email: 'john.doe@student.edu',
        major: 'Computer Science',
        year: 2
      )
      expect(student).to be_valid
    end

    it 'requires a name' do
      student.update(name: nil)
      expect(student).not_to be_valid
      expect(student.errors[:name]).to include("can't be blank")
    end

    it 'requires an email' do
      student.update(email: nil)
      expect(student).not_to be_valid
      expect(student.errors[:email]).to include("can't be blank")
    end

    it 'requires a major' do
      student.update(major: nil)
      expect(student).not_to be_valid
      expect(student.errors[:major]).to include("can't be blank")
    end

    it 'requires a year' do
      student.update(year: nil)
      expect(student).not_to be_valid
      expect(student.errors[:year]).to include("can't be blank")
    end

    it 'requires unique email' do
      duplicate = Student.new(**student.attributes)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include('has already been taken')
    end

    it 'requires unique student ID' do
      duplicate = Student.new(**student.attributes)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:student_id]).to include('has already been taken')
    end

    it 'validates email format' do
      student = Student.new(name: 'John Doe', email: 'invalid-email', major: 'CS', year: 2)
      expect(student).not_to be_valid
      expect(student.errors[:email]).to include('is invalid')

      student.email = 'john.doe@student.edu'
      expect(student).to be_valid
    end

    it 'requires year to be between 1 and 5' do
      student.update(year: 0)
      expect(student).not_to be_valid
      expect(student.errors[:year]).to include('must be greater than 0')

      student.update(year: 6)
      expect(student).not_to be_valid
      expect(student.errors[:year]).to include('must be less than or equal to 5')

      student.year = 3
      expect(student).to be_valid
    end
  end
end
