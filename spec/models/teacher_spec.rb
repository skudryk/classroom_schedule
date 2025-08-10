require 'spec_helper'

RSpec.describe Teacher, type: :model do
  let (:teacher) {Teacher.new(name: 'John Doe',  email: 'john.doe@example.com', department: 'Computer Science')}

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(teacher).to be_valid
    end

    it 'is not valid without a name' do
      teacher.update(name: nil)
      expect(teacher).not_to be_valid
      expect(teacher.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      teacher.update(email: nil)
      expect(teacher).not_to be_valid
      expect(teacher.errors[:email]).to include("can't be blank")
    end

    it 'is not valid without a department' do
      teacher.update(departament: nil)
      expect(teacher).not_to be_valid
      expect(teacher.errors[:department]).to include("can't be blank")
    end

    it 'is not valid with an invalid email format' do
      teacher.update(email: 'invalid email.address')
      expect(teacher).not_to be_valid
      expect(teacher.errors[:email]).to include('is invalid')
    end
  end

  describe 'associations' do
    it 'has many sections' do
      expect(Teacher.reflect_on_association(:sections).macro).to eq :has_many
    end

    it 'has many subjects through sections' do
      expect(Teacher.reflect_on_association(:subjects).macro).to eq :has_many
    end
  end
end
