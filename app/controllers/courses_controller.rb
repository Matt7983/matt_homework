# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :set_course, only: %i[update destroy]

  # GET /courses
  def index
    courses = Course.includes(chapters: :units).order(:id).order('chapters.sequence asc, units.sequence asc')

    render json: CoursePrinter.render(courses, view: :with_chapters_and_units)
  end

  # GET /courses/1
  def show
    course = Course.includes(chapters: :units).order('chapters.sequence asc, units.sequence asc').find(params[:id])

    render json: CoursePrinter.render(course, view: :with_chapters_and_units)
  end

  # POST /courses
  def create
    course = Course.create!(course_params)

    render json: CoursePrinter.render(course, view: :with_chapters_and_units), status: :created
  rescue ActiveRecord::NotNullViolation
    render json: { error_code: 'PARAMETER_MISSING' }, status: 400
  end

  # PATCH/PUT /courses/1
  def update
    @course.update!(course_params)

    render json: CoursePrinter.render(@course, view: :with_chapters_and_units)
  rescue ActiveRecord::NotNullViolation
    render json: { error_code: 'PARAMETER_MISSING' }, status: 400
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
    render json: { success: true }
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :lecturer, :description, :available,
                                   chapters_attributes:
                                     [:id, :name, :sequence, :_destroy,
                                      { units_attributes: %i[id name description content sequence _destroy] }])
  end
end
