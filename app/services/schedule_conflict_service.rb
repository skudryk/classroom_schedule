class ScheduleConflictService
  def initialize(student, section)
    @student = student
    @section = section
  end

  def has_conflicts?
    conflicting_sections.exists?
  end

  def conflicting_sections
    @conflicting_sections ||= @student.sections.joins(:enrollments)
      .where(enrollments: { status: 'enrolled' })
      .overlapping(@section.start_time, @section.end_time, @section.days_of_week)
      .where.not(id: @section.id)
  end

  private

  def determine_conflict_type(conflict)
    if conflict.days_of_week.any? { |day| @section.days_of_week.include?(day) }
      if time_overlaps?(conflict)
        'time_overlap'
      else
        'day_overlap'
      end
    else
      'no_overlap'
    end
  end

  def time_overlaps?(conflict)
    (@section.start_time < conflict.end_time) && (@section.end_time > conflict.start_time)
  end
end
