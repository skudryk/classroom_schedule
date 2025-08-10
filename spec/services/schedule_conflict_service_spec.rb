require 'spec_helper'

RSpec.describe ScheduleConflictService, type: :service do
  let(:teacher) { Teacher.create!(name: 'John Doe', email: 'john@example.com', department: 'CS') }
  let(:subject) { Subject.create!(name: 'Programming', code: 'CS101', credits: 3) }
  let(:classroom) { Classroom.create!(name: 'Lab A', building: 'Building 1', capacity: 25, room_number: '101') }
  let(:student) { Student.create!(name: 'Alice Smith', email: 'alice@student.edu', student_id: 'S001', major: 'CS', year: 2) }
  
  let(:section1) do
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

  let(:section3) do
    Section.create!(
      teacher: teacher,
      subject: subject,
      classroom: classroom,
      start_time: '10:00',
      end_time: '10:50',
      days_of_week: ['monday', 'wednesday', 'friday'],
      duration_minutes: 50,
      capacity: 25
    )
  end

  let(:section4) do
    Section.create!(
      teacher: teacher,
      subject: subject,
      classroom: classroom,
      start_time: '09:00',
      end_time: '09:50',
      days_of_week: ['tuesday', 'thursday'],
      duration_minutes: 50,
      capacity: 25
    )
  end

  describe '#initialize' do
    it 'sets student and section' do
      service = ScheduleConflictService.new(student, section1)
      expect(service.instance_variable_get(:@student)).to eq student
      expect(service.instance_variable_get(:@section)).to eq section1
    end
  end

  describe '#has_conflicts?' do
    context 'when there are no conflicts' do
      it 'returns false' do
        service = ScheduleConflictService.new(student, section1)
        expect(service.has_conflicts?).to be false
      end
    end

    context 'when there are time conflicts' do
      before do
        Enrollment.create!(student: student, section: section1, status: 'enrolled')
      end

      it 'returns true for overlapping time on same days' do
        service = ScheduleConflictService.new(student, section2)
        expect(service.has_conflicts?).to be true
      end

      it 'returns false for different days' do
        service = ScheduleConflictService.new(student, section4)
        expect(service.has_conflicts?).to be false
      end

      it 'returns false for non-overlapping times on same days' do
        service = ScheduleConflictService.new(student, section3)
        expect(service.has_conflicts?).to be false
      end
    end

    context 'when there are multiple conflicts' do
      before do
        Enrollment.create!(student: student, section: section1, status: 'enrolled')
        Enrollment.create!(student: student, section: section2, status: 'enrolled')
      end

      it 'returns true' do
        service = ScheduleConflictService.new(student, section3)
        expect(service.has_conflicts?).to be true
      end
    end
  end

  describe '#conflicting_sections' do
    context 'when there are no conflicts' do
      it 'returns empty array' do
        service = ScheduleConflictService.new(student, section1)
        expect(service.conflicting_sections).to be_empty
      end
    end

    context 'when there are conflicts' do
      before do
        Enrollment.create!(student: student, section: section1, status: 'enrolled')
      end

      it 'returns conflicting sections' do
        service = ScheduleConflictService.new(student, section2)
        expect(service.conflicting_sections).to include(section1)
        expect(service.conflicting_sections.count).to eq 1
      end

      it 'excludes the current section being checked' do
        service = ScheduleConflictService.new(student, section1)
        expect(service.conflicting_sections).to be_empty
      end
    end

    context 'when there are multiple conflicts' do
      before do
        Enrollment.create!(student: student, section: section1, status: 'enrolled')
        Enrollment.create!(student: student, section: section2, status: 'enrolled')
      end

      it 'returns all conflicting sections' do
        service = ScheduleConflictService.new(student, section3)
        expect(service.conflicting_sections).to include(section1, section2)
        expect(service.conflicting_sections.count).to eq 2
      end
    end
  end

  describe '#conflict_details' do
    context 'when there are no conflicts' do
      it 'returns empty array' do
        service = ScheduleConflictService.new(student, section1)
        expect(service.conflict_details).to be_empty
      end
    end

    context 'when there are conflicts' do
      before do
        Enrollment.create!(student: student, section: section1, status: 'enrolled')
      end

      it 'returns detailed conflict information' do
        service = ScheduleConflictService.new(student, section2)
        conflicts = service.conflict_details
        
        expect(conflicts.count).to eq 1
        conflict = conflicts.first
        
        expect(conflict[:id]).to eq section1.id
        expect(conflict[:subject]).to eq section1.subject.name
        expect(conflict[:teacher]).to eq section1.teacher.name
        expect(conflict[:classroom]).to eq section1.classroom.name
        expect(conflict[:start_time]).to eq section1.start_time.strftime('%H:%M')
        expect(conflict[:end_time]).to eq section1.end_time.strftime('%H:%M')
        expect(conflict[:days_of_week]).to eq section1.days_of_week
        expect(conflict[:conflict_type]).to eq 'time_overlap'
      end
    end

    context 'with different conflict types' do
      let(:section_same_time_different_days) do
        Section.create!(
          teacher: teacher,
          subject: subject,
          classroom: classroom,
          start_time: '09:00',
          end_time: '09:50',
          days_of_week: ['tuesday', 'thursday'],
          duration_minutes: 50,
          capacity: 25
        )
      end

      it 'identifies time overlap conflicts' do
        Enrollment.create!(student: student, section: section1, status: 'enrolled')
        service = ScheduleConflictService.new(student, section2)
        conflicts = service.conflict_details
        
        expect(conflicts.first[:conflict_type]).to eq 'time_overlap'
      end

      it 'identifies day overlap conflicts' do
        Enrollment.create!(student: student, section: section1, status: 'enrolled')
        service = ScheduleConflictService.new(student, section_same_time_different_days)
        conflicts = service.conflict_details
        
        expect(conflicts.first[:conflict_type]).to eq 'day_overlap'
      end
    end
  end


  describe 'edge cases' do
    it 'handles sections with no enrollments' do
      service = ScheduleConflictService.new(student, section1)
      expect(service.has_conflicts?).to be false
      expect(service.conflicting_sections).to be_empty
    end

    it 'handles student with no enrollments' do
      new_student = Student.create!(name: 'Bob Smith', email: 'bob@student.edu', student_id: 'S002', major: 'CS', year: 2)
      service = ScheduleConflictService.new(new_student, section1)
      expect(service.has_conflicts?).to be false
      expect(service.conflicting_sections).to be_empty
    end

  end
end
