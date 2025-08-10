
p"Clearing existing data..."

Enrollment.destroy_all
Section.destroy_all
Student.destroy_all
Teacher.destroy_all
Subject.destroy_all
Classroom.destroy_all


p "Creating teachers..."
[
  { name: 'Dr. John Smith', email: 'john.smith@university.edu', department: 'Computer Science', phone: '555-0101' },
  { name: 'Prof. Sarah Johnson', email: 'sarah.johnson@university.edu', department: 'Mathematics', phone: '555-0102' },
  { name: 'Dr. Michael Brown', email: 'michael.brown@university.edu', department: 'Physics', phone: '555-0103' },
].each do |teacher_attrs|
  Teacher.create!(teacher_attrs)
end


p "Creating subjects..."
[
  { name: 'Introduction to Programming', code: 'CS101', description: 'Basic programming concepts using Python', credits: 3 },
  { name: 'Calculus I', code: 'MATH201', description: 'Differential calculus and applications', credits: 4 },
  { name: 'Physics Fundamentals', code: 'PHYS101', description: 'Basic physics principles and mechanics', credits: 4 },
].each do |subject_attrs|
  Subject.create!(subject_attrs)
end


p "Creating classrooms..."
[
  { name: 'Computer Lab A', building: 'Science Building', capacity: 25, room_number: 'SB-101' },
  { name: 'Lecture Hall 1', building: 'Main Hall', capacity: 100, room_number: 'MH-201' },
  { name: 'Physics Lab', building: 'Science Building', capacity: 30, room_number: 'SB-202' },
].each do |classroom_attrs|
  Classroom.create!(classroom_attrs)
end

p "Creating students..."
 [
  { name: 'Alice Johnson', email: 'alice.johnson@student.edu', student_id: 'S001', major: 'Computer Science', year: 2 },
  { name: 'Bob Smith', email: 'bob.smith@student.edu', student_id: 'S002', major: 'Mathematics', year: 3 },
  { name: 'Carol Davis', email: 'carol.davis@student.edu', student_id: 'S003', major: 'Physics', year: 1 },
  { name: 'David Wilson', email: 'david.wilson@student.edu', student_id: 'S004', major: 'English', year: 2 },
  { name: 'Eva Brown', email: 'eva.brown@student.edu', student_id: 'S005', major: 'History', year: 4 }
].each do |student_attrs|
  Student.create!(student_attrs)
end

p "Creating sections..."
sections = [
  {
    teacher: Teacher.find_by(name: 'Dr. John Smith'),
    subject: Subject.find_by(code: 'CS101'),
    classroom: Classroom.find_by(name: 'Computer Lab A'),
    start_time: '09:00',
    end_time: '09:50',
    days_of_week: ['monday', 'wednesday', 'friday'],
    duration_minutes: 50
  },
  {
    teacher: Teacher.find_by(name: 'Prof. Sarah Johnson'),
    subject: Subject.find_by(code: 'MATH201'),
    classroom: Classroom.find_by(name: 'Lecture Hall 1'),
    start_time: '10:00',
    end_time: '11:20',
    days_of_week: ['tuesday', 'thursday'],
    duration_minutes: 80
  },
  {
    teacher: Teacher.find_by(name: 'Dr. Michael Brown'),
    subject: Subject.find_by(code: 'PHYS101'),
    classroom: Classroom.find_by(name: 'Physics Lab'),
    start_time: '14:00',
    end_time: '15:20',
    days_of_week: ['monday', 'wednesday', 'friday'],
    duration_minutes: 80
  }
]

sections.each do |section_attrs|
  Section.create!(section_attrs)
end

p "Creating enrollments..."
enrollments = [
  { student: Student.find_by(name: 'Alice Johnson'), section: Section.first, enrollment_date: Date.current, status: 'enrolled' },
  { student: Student.find_by(name: 'Bob Smith'), section: Section.second, enrollment_date: Date.current, status: 'enrolled' },
  { student: Student.find_by(name: 'Alice Johnson'), section: Section.third, enrollment_date: Date.current, status: 'enrolled' },
  { student: Student.find_by(name: 'Carol Davis'), section: Section.fourth, enrollment_date: Date.current, status: 'enrolled' }
]

enrollments.each do |enrollment_attrs|
  Enrollment.create!(enrollment_attrs)
end

p "Seed data created successfully!"

