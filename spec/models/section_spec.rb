require 'spec_helper'

RSpec.describe Section, type: :model do
  let(:teacher) { Teacher.create!(name: 'John Doe', email: 'john@example.com', department: 'CS') }
  let(:subject) { Subject.create!(name: 'Programming', code: 'CS101', credits: 3) }
  let(:classroom) { Classroom.create!(name: 'Lab A', building: 'Building 1', capacity: 25, room_number: '101') }
  let(:student) { Student.create!(name: 'Alice Smith', email: 'alice@student.edu', student_id: 'S001', major: 'CS', year: 2) }
  let (:section) do
     Section.new(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '09:00',
        end_time: '09:50',
        days_of_week: ['monday', 'wednesday', 'friday'],
        duration_minutes: 50,
        capacity: 25
      )
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(section).to be_valid
    end

    it 'requires a teacher' do
      section.teacher = nil
      expect(section).not_to be_valid
      expect(section.errors[:teacher]).to include('must exist')
    end

    it 'requires a subject' do
      section.subject = nil
      expect(section).not_to be_valid
      expect(section.errors[:subject]).to include('must exist')
    end

    it 'requires a classroom' do
      section.classroom = nil
      expect(section).not_to be_valid
      expect(section.errors[:classroom]).to include('must exist')
    end

    it 'requires start time' do
      section.start_time = nil
      expect(section).not_to be_valid
      expect(section.errors[:start_time]).to include("can't be blank")
    end

    it 'requires end time' do
      section.end_time = nil
      expect(section).not_to be_valid
      expect(section.errors[:end_time]).to include("can't be blank")
    end

    it 'requires days of week' do
       section.days_of_week = []l
      expect(section).not_to be_valid
      expect(section.errors[:days_of_week]).to include("can't be blank")
    end

    it 'requires duration minutes' do
      section.duration_minutes = nil
      expect(section).not_to be_valid
      expect(section.errors[:duration_minutes]).to include("can't be blank")
    end

    it 'requires capacity' do
       section.capacity = nil
      expect(section).not_to be_valid
      expect(section.errors[:capacity]).to include("can't be blank")
    end

    it 'validates duration minutes inclusion' do
      section.duration_minutes = nil
      expect(section).not_to be_valid
      expect(section.errors[:duration_minutes]).to include('is not included in the list')
    end

    it 'validates start time is before end time' do
      section = Section.new(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '10:00',
        end_time: '09:00',
        days_of_week: ['monday', 'wednesday', 'friday'],
        duration_minutes: 50,
        capacity: 25
      )
      expect(section).not_to be_valid
      expect(section.errors[:end_time]).to include('must be after start time')
    end

    it 'validates time within bounds' do
      section = Section.new(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '06:00',
        end_time: '06:50',
        days_of_week: ['monday', 'wednesday', 'friday'],
        duration_minutes: 50,
        capacity: 25
      )
      expect(section).not_to be_valid
      expect(section.errors[:base]).to include('Sections must be between 7:30 AM and 10:00 PM')
    end

    it 'validates duration matches times' do
      section = Section.new(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '09:00',
        end_time: '09:50',
        days_of_week: ['monday', 'wednesday', 'friday'],
        duration_minutes: 80,
        capacity: 25
      )
      expect(section).not_to be_valid
      expect(section.errors[:duration_minutes]).to include('must match the difference between start and end times')
    end

    it 'validates days of week format' do
      section = Section.new(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '09:00',
        end_time: '09:50',
        days_of_week: ['invalid_day'],
        duration_minutes: 50,
        capacity: 25
      )
      expect(section).not_to be_valid
      expect(section.errors[:days_of_week]).to include('must contain valid day names')
    end

    it 'validates capacity does not exceed classroom capacity' do
      section = Section.new(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '09:00',
        end_time: '09:50',
        days_of_week: ['monday', 'wednesday', 'friday'],
        duration_minutes: 50,
        capacity: 30
      )
      expect(section).not_to be_valid
      expect(section.errors[:capacity]).to include('cannot exceed classroom capacity (25)')
    end
  end

  describe 'associations' do
    it 'belongs to a teacher' do
      expect(Section.reflect_on_association(:teacher).macro).to eq :belongs_to
    end

    it 'belongs to a subject' do
      expect(Section.reflect_on_association(:subject).macro).to eq :belongs_to
    end

    it 'belongs to a classroom' do
      expect(Section.reflect_on_association(:classroom).macro).to eq :belongs_to
    end

    it 'has many enrollments' do
      expect(Section.reflect_on_association(:enrollments).macro).to eq :has_many
    end

    it 'has many students through enrollments' do
      expect(Section.reflect_on_association(:students).macro).to eq :has_many
    end
  end

  describe 'scopes' do
    let!(:monday_section) do
      Section.create!(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '09:00',
        end_time: '09:50',
        days_of_week: ['monday'],
        duration_minutes: 50,
        capacity: 25
      )
    end

    let!(:tuesday_section) do
      Section.create!(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '10:00',
        end_time: '10:50',
        days_of_week: ['tuesday'],
        duration_minutes: 50,
        capacity: 25
      )
    end

    it 'filters sections by day' do
      expect(Section.on_day('monday')).to include(monday_section)
      expect(Section.on_day('monday')).not_to include(tuesday_section)
    end

    it 'finds overlapping sections' do
      overlapping_section = Section.create!(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '09:30',
        end_time: '10:20',
        days_of_week: ['monday'],
        duration_minutes: 50,
        capacity: 25
      )

      overlapping = Section.overlapping('09:00', '10:00', ['monday'])
      expect(overlapping).to include(monday_section)
      expect(overlapping).to include(overlapping_section)
    end
  end
end
