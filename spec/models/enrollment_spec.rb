require 'spec_helper'

RSpec.describe Enrollment, type: :model do
  let(:teacher) { Teacher.create!(name: 'John Doe', email: 'john@example.com', department: 'CS') }
  let(:subject) { Subject.create!(name: 'Programming', code: 'CS101', credits: 3) }
  let(:classroom) { Classroom.create!(name: 'Lab A', building: 'Building 1', capacity: 25, room_number: '101') }
  let(:student) { Student.create!(name: 'Alice Smith', email: 'alice@student.edu', student_id: 'S001', major: 'CS', year: 2) }
  let(:section) do
    Section.create!(
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
    it 'is valid with correct attributes' do
      enrollment = Enrollment.new(
        student: student,
        section: section,
        enrollment_date: Date.current,
        status: 'enrolled'
      )
      expect(enrollment).to be_valid
    end

    it 'requires a student' do
      enrollment = Enrollment.new(
        section: section,
        enrollment_date: Date.current,
        status: 'enrolled'
      )
      expect(enrollment).not_to be_valid
      expect(enrollment.errors[:student]).to include('must exist')
    end

    it 'requires a section' do
      enrollment = Enrollment.new(
        student: student,
        enrollment_date: Date.current,
        status: 'enrolled'
      )
      expect(enrollment).not_to be_valid
      expect(enrollment.errors[:section]).to include('must exist')
    end

    it 'requires unique student and section combination' do
      Enrollment.create!(student: student, section: section, status: 'enrolled')
      duplicate = Enrollment.new(student: student, section: section, status: 'waitlisted')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:student_id]).to include('is already enrolled in this section')
    end

    it 'accepts valid statuses' do
      valid_statuses = %w[enrolled waitlisted dropped]
      
      valid_statuses.each do |status|
        enrollment = Enrollment.new(
          student: student,
          section: section,
          enrollment_date: Date.current,
          status: status
        )
        expect(enrollment).to be_valid
      end
    end
  end
 
  
  describe 'schedule conflict detection' do
    let(:section2) do
      Section.create!(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '09:30',
        end_time: '10:20',
        days_of_week: ['monday', 'wednesday', 'friday'],
        duration_minutes: 50,
        capacity: 25
      )
    end

    it 'prevents enrollment in overlapping sections on same days' do
      Enrollment.create!(student: student, section: section, status: 'enrolled')
      
      overlapping_enrollment = Enrollment.new(
        student: student,
        section: section2,
        status: 'enrolled'
      )

      expect(overlapping_enrollment).not_to be_valid
      expect(overlapping_enrollment.errors[:base]).to include('Cannot enroll in overlapping sections')
    end

    it 'allows enrollment in sections on different days' do
      different_day_section = Section.create!(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '09:00',
        end_time: '09:50',
        days_of_week: ['tuesday', 'thursday'],
        duration_minutes: 50,
        capacity: 25
      )

      Enrollment.create!(student: student, section: section, status: 'enrolled')
      
      different_day_enrollment = Enrollment.new(
        student: student,
        section: different_day_section,
        status: 'enrolled'
      )

      expect(different_day_enrollment).to be_valid
    end

    it 'allows enrollment in sections with different times on same days' do
      different_time_section = Section.create!(
        teacher: teacher,
        subject: subject,
        classroom: classroom,
        start_time: '10:00',
        end_time: '10:50',
        days_of_week: ['monday', 'wednesday', 'friday'],
        duration_minutes: 50,
        capacity: 25
      )

      Enrollment.create!(student: student, section: section, status: 'enrolled')
      
      different_time_enrollment = Enrollment.new(
        student: student,
        section: different_time_section,
        status: 'enrolled'
      )

      expect(different_time_enrollment).to be_valid
    end
  end
end
