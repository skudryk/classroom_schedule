class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :section
  
  validates :student_id, uniqueness: { scope: :section_id, message: "is already enrolled in this section" }
  validates :status, inclusion: { in: %w[enrolled waitlisted dropped] }
  
  before_create :set_default_status
  before_create :check_schedule_conflicts
  
  scope :enrolled, -> { where(status: 'enrolled') }
  scope :waitlisted, -> { where(status: 'waitlisted') }
  scope :dropped, -> { where(status: 'dropped') }
  
  def is_enrolled?
    status == 'enrolled'
  end
  
  def is_waitlisted?
    status == 'waitlisted'
  end
  
  def is_dropped?
    status == 'dropped'
  end
  
 
  private
  
  # callback actions
  def set_default_status
    self.status ||= 'enrolled'
  end
  
  def check_schedule_conflicts
    return if status == 'dropped'
    
    conflicting_sections = student.sections.joins(:enrollments)
      .where(enrollments: { status: 'enrolled' })
      .overlapping(section.start_time, section.end_time, section.days_of_week)
      .where.not(id: section.id)
    
    if conflicting_sections.exists?
      errors.add(:base, "Cannot enroll in overlapping sections")
      throw(:abort)
    end
  end
end
