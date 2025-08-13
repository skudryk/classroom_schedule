
p"Clearing existing data..."

Enrollment.destroy_all
Section.destroy_all
Student.destroy_all
Teacher.destroy_all
Subject.destroy_all
Classroom.destroy_all


p "Creating teachers..."
[
  { account_attributes: {name: 'Dr. John Smith', email: 'john.smith@university.edu',  phone: '555-0101' }, department: 'Computer Science', },
  { account_attributes: {name: 'Prof. Sarah Johnson', email: 'sarah.johnson@university.edu', phone: '555-0102' },  department: 'Mathematics'},
  { account_attributes: {name: 'Dr. Michael Brown', email: 'michael.brown@university.edu',  phone: '555-0103' }, department: 'Physics'},
].each do |teacher_attrs|
  Teacher.create(teacher_attrs)
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
  {account_attributes: {name: 'Alice Johnson', email: 'alice.johnson@student.edu'},  major: 'Computer Science', year: 2 },
  {account_attributes: {name: 'Bob Smith', email: 'bob.smith@student.edu'}, major: 'Mathematics', year: 3 },
  {account_attributes: {name: 'Carol Davis', email: 'carol.davis@student.edu'}, major: 'Physics', year: 1 },
  {account_attributes: {name: 'David Wilson', email: 'david.wilson@student.edu'}, major: 'English', year: 2 },
  {account_attributes: {name: 'Eva Brown', email: 'eva.brown@student.edu'}, major: 'History', year: 4 }
].each do |student_attrs|
  Student.create(student_attrs)
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
[
  { student: Student.find_by(name: 'Alice Johnson'), section: Section.first, enrollment_date: Date.current, status: 'enrolled' },
  { student: Student.find_by(name: 'Bob Smith'), section: Section.second, enrollment_date: Date.current, status: 'enrolled' },
  { student: Student.find_by(name: 'Alice Johnson'), section: Section.third, enrollment_date: Date.current, status: 'enrolled' },
  { student: Student.find_by(name: 'Carol Davis'), section: Section.fourth, enrollment_date: Date.current, status: 'enrolled' }
].each do |enrollment_attrs|
  Enrollment.create!(enrollment_attrs)
end

p "Seed data created successfully!"

