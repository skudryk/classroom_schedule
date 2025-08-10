require 'spec_helper'

RSpec.describe Classroom, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      # TODO - use factory bot records
      classroom = Classroom.new(
        name: 'Computer Lab A',
        building: 'Science Building',
        capacity: 25,
        room_number: 'SB-101'
      )
      expect(classroom).to be_valid
    end

    it 'requires a name' do
      classroom = Classroom.new(building: 'Science Building', capacity: 25, room_number: 'SB-101')
      expect(classroom).not_to be_valid
      expect(classroom.errors[:name]).to include("can't be blank")
    end

    it 'requires a building' do
      classroom = Classroom.new(name: 'Computer Lab A', capacity: 25, room_number: 'SB-101')
      expect(classroom).not_to be_valid
      expect(classroom.errors[:building]).to include("can't be blank")
    end

    it 'requires capacity' do
      classroom = Classroom.new(name: 'Computer Lab A', building: 'Science Building', room_number: 'SB-101')
      expect(classroom).not_to be_valid
      expect(classroom.errors[:capacity]).to include("can't be blank")
    end

    it 'requires room number' do
      classroom = Classroom.new(name: 'Computer Lab A', building: 'Science Building', capacity: 25)
      expect(classroom).not_to be_valid
      expect(classroom.errors[:room_number]).to include("can't be blank")
    end

    it 'requires capacity to be greater than 0' do
      classroom = Classroom.new(name: 'Lab A', building: 'Building 1', capacity: 0, room_number: '101')
      expect(classroom).not_to be_valid
      expect(classroom.errors[:capacity]).to include('must be greater than 0')

      classroom.capacity = -1
      expect(classroom).not_to be_valid
      expect(classroom.errors[:capacity]).to include('must be greater than 0')
    end

    it 'requires unique building and room number combination' do
      Classroom.create!(name: 'Lab A', building: 'Building 1', capacity: 25, room_number: '101')
      duplicate = Classroom.new(name: 'Lab B', building: 'Building 1', capacity: 30, room_number: '101')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:building]).to include('has already been taken')
    end
  end

end
