class Api::SectionsController < ApplicationController
  before_action :set_section, only: [:show, :update, :destroy, :enroll, :unenroll]
  PER_PAGE = 10

  def index
    per_page = params[:limit].present? ? params[:limit].to_i : PER_PAGE
    page =  params[:page].present? ? params[:page].to_i : 1

    @sections = Section.includes(:teacher, :subject, :classroom).all.limit(per_page).offset((page  - 1) * per_page)
    render json: @sections
  end

  def show
    render json: @section
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      render json: @section, status: :created
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  def update
    if @section.update(section_params)
      render json: @section
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @section.destroy
    head :no_content
  end

  def enroll
    student_id = params[:student_id]
    student = Student.find(student_id)
    
    enrollment = @section.enrollments.build(
      student: student,
      enrollment_date: Date.current,
      status: 'enrolled'
    )

    if enrollment.save
      render json: { message: "Student enrolled successfully", enrollment: enrollment }
    else
      render json: { errors: enrollment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unenroll
    student_id = params[:student_id]
    enrollment = @section.enrollments.find_by(student_id: student_id)
    
    if enrollment
      enrollment.update(status: 'dropped')
      render json: { message: "Student unenrolled successfully" }
    else
      render json: { error: "Student not found in this section" }, status: :not_found
    end
  end

  def available
    @sections = Section.includes(:teacher, :subject, :classroom)
      .where.not(id: Enrollment.where(student_id: params[:student_id], status: 'enrolled').select(:section_id))
      .all
    
    render json: @sections
  end

  def conflicts
    student_id = params[:student_id]
    section_id = params[:section_id]
    
    if student_id && section_id
      section = Section.find(section_id)
      student = Student.find(student_id)
      
      conflicting_sections = student.sections.joins(:enrollments)
        .where(enrollments: { status: 'enrolled' })
        .overlapping(section.start_time, section.end_time, section.days_of_week)
        .where.not(id: section.id)
      
      render json: {
        has_conflicts: conflicting_sections.exists?,
        conflicting_sections: conflicting_sections.map do |conflict|
          {
            id: conflict.id,
            subject: conflict.subject.name,
            start_time: conflict.start_time.strftime("%H:%M"),
            end_time: conflict.end_time.strftime("%H:%M"),
            days_of_week: conflict.days_of_week
          }
        end
      }
    else
      render json: { error: "Both student_id and section_id are required" }, status: :bad_request
    end
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:teacher_id, :subject_id, :classroom_id, :start_time, :end_time, :days_of_week, :duration_minutes)
  end
end
