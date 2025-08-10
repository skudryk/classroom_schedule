class Section < ApplicationRecord

  belongs_to :teacher
  belongs_to :subject
  belongs_to :classroom
  
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :days_of_week, presence: true
  validates :duration_minutes, presence: true, inclusion: { in: [50, 80] }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  
  #  some custom validators
  validate :start_time_before_end_time
  validate :time_within_bounds
  validate :duration_matches_times
  validate :days_of_week_format
  validate :capacity_not_exceed_classroom
  
  scope :on_day, ->(day) { where("? = ANY(days_of_week)", day.downcase) }
   scope :overlapping, ->(start_time, end_time, days) { 
    where("days_of_week && ?", days)
    .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)
  }
  
  def enrolled_students_count
    enrollments.where(status: 'enrolled').count
  end
  
  
  def available_spots
    capacity - enrolled_students_count
  end
  
  def has_available_spots?
    available_spots > 0
  end
  
  def is_full?
    available_spots <= 0
  end
  
  def can_enroll_student?
    has_available_spots?
  end
   
  private
  
  # Validators
  def start_time_before_end_time
    return unless start_time && end_time
    
    if start_time >= end_time
      errors.add(:end_time, "must be after start time")
    end
  end
  
  def time_within_bounds
    return unless start_time && end_time
    
    earliest_start = Time.parse("07:30")
    latest_end = Time.parse("22:00")
    
    if start_time < earliest_start || end_time > latest_end
      errors.add(:base, "Sections must be between 7:30 AM and 10:00 PM")
    end
  end
  
  def duration_matches_times
    return unless start_time && end_time && duration_minutes
    
    calc_duration = (end_time - start_time) / 60
    
    if calc_duration != duration_minutes
      errors.add(:duration_minutes, "must match the difference between start and end times")
    end
  end
  
  def days_of_week_format
    return unless days_of_week
    
    valid_days = %w[monday tuesday wednesday thursday friday saturday sunday]
    
    unless days_of_week.all? { |day| valid_days.include?(day.downcase) }
      errors.add(:days_of_week, "must contain valid day names")
    end
  end
  
  def capacity_not_exceed_classroom
    return unless capacity && classroom
    
    if capacity > classroom.capacity
      errors.add(:capacity, "cannot exceed classroom capacity (#{classroom.capacity})")
    end
  end
end
