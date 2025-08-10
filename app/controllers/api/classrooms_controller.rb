class Api::ClassroomsController < ApplicationController
  before_action :set_classroom, only: [:show, :update, :destroy]

  def index
    @classrooms = Classroom.all
    render json: @classrooms
  end

  def show
    render json: @classroom
  end

  def create
    @classroom = Classroom.new(classroom_params)

    if @classroom.save
      render json: @classroom, status: :created
    else
      render json: @classroom.errors, status: :unprocessable_entity
    end
  end

  def update
    if @classroom.update(classroom_params)
      render json: @classroom
    else
      render json: @classroom.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @classroom.destroy
    head :no_content
  end

  private

  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  def classroom_params
    params.require(:classroom).permit(:name, :building, :capacity, :room_number)
  end
end
