class Api::StudentsController < ApplicationController
  before_action :set_student, only: [:show, :update, :destroy, :schedule, :schedule_pdf]

  def index
    @students = Student.all
    render json: @students
  end

  def show
    render json: @student
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      render json: @student, status: :created
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  def update
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    head :no_content
  end

  def schedule
    @enrollments = @student.enrollments.includes(:section => [:teacher, :subject, :classroom])
    render json: {
      student: @student,
      schedule: @enrollments
    }
  end

  def schedule_pdf
    pdf_service = PdfGeneratorService.new(@student)
    pdf_content = pdf_service.generate_schedule_pdf
    
    send_data pdf_content, 
      filename: "#{@student.name}_schedule.pdf",
      type: 'application/pdf',
      disposition: 'attachment'
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :email, :student_id, :major, :year)
  end
end
