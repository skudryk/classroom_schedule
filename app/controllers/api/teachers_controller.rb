class Api::TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :update, :destroy]

  def index
    @teachers = Teacher.all
    render json: @teachers
  end

  def show
    render json: @teacher
  end

  def create
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      render json: @teacher, status: :created
    else
      render json: @teacher.errors, status: :unprocessable_entity
    end
  end

  def update
    if @teacher.update(teacher_params)
      render json: @teacher
    else
      render json: @teacher.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @teacher.destroy
    head :no_content
  end

  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def teacher_params
    params.require(:teacher).permit(:name, :email, :department, :phone)
  end
end
