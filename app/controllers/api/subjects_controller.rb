class Api::SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :update, :destroy]

  def index
    @subjects = Subject.all
    render json: @subjects
  end

  def show
    render json: @subject
  end

  def create
    @subject = Subject.new(subject_params)

    if @subject.save
      render json: @subject, status: :created
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  def update
    if @subject.update(subject_params)
      render json: @subject
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @subject.destroy
    head :no_content
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:name, :code, :description, :credits)
  end
end
