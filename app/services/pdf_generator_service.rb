class PdfGeneratorService

  def initialize(student)
    @student = student
  end

  def generate_schedule_pdf
    Prawn::Document.new do |pdf|

      pdf.text "Student Schedule", size: 24, style: :bold, align: :center
      pdf.move_down 20
      
      pdf.text "Student Information", size: 16, style: :bold
      pdf.text "Name: #{@student.name}"
      pdf.text "Email: #{@student.email}"
      pdf.text "Student ID: #{@student.student_id}"
      pdf.text "Major: #{@student.major}"
      pdf.text "Year: #{@student.year}"
      pdf.move_down 20
      
        pdf.text "Weekly Schedule", size: 16, style: :bold
      pdf.move_down 10
      
      enrollments = @student.enrollments.includes(section: [:teacher, :subject, :classroom]).where(status: 'enrolled')
      
      if enrollments.any?
        days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        time_slots = generate_time_slots
        
        table_data = [['Time'] + days]
        
        time_slots.each do |time_slot|
          row = [time_slot]
          days.each do |day|
            section_info = find_section_at_time(enrollments, day, time_slot)
            row << (section_info || '')
          end
          table_data << row
        end
        
        # finally generate
        pdf.table(table_data, header: true, width: pdf.bounds.width) do
          row(0).style(background_color: 'CCCCCC', font_style: :bold)
          cells.style(borders: [:top, :bottom, :left, :right], padding: 5)
        end
      else
        pdf.text "No courses enrolled", style: :italic
      end
      
      # footer
      pdf.move_down 30
      pdf.text "Generated on: #{Date.current.strftime('%B %d, %Y')}", size: 10, align: :center
    end
  end

  private

  def generate_time_slots
    slots = []
    # TODO - use constantas
    current_time = Time.parse("07:30")
    end_time = Time.parse("22:00")
    
    while current_time <= end_time
      slots << current_time.strftime("%H:%M")
      current_time += 50.minutes
    end
    
    slots
  end

  def find_section_at_time(enrollments, day, time_slot)
    time = Time.parse(time_slot)
    
    enrollments.each do |enrollment|
      section = enrollment.section
      next unless section.days_of_week.include?(day.downcase)
      
      if time >= section.start_time && time < section.end_time
        return "#{section.subject.name}\n#{section.teacher.name}\n#{section.classroom.name}"
      end
    end
    
  end
end
