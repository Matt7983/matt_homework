# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  describe 'GET /courses' do
    subject(:do_get) do
      get '/courses'
      response
    end

    let!(:courses) { FactoryBot.create_list(:course, 2, :with_chapter_and_unit) }

    it 'returns a 200' do
      expect(do_get).to have_http_status(:ok)
    end

    it 'returns all courses with CoursePrinter wrapped.' do
      expect(do_get.body).to eq(CoursePrinter.render(courses, view: :with_chapters_and_units))
    end

    context 'when there are multi chapters in a course' do
      let!(:course) { FactoryBot.create(:course) }
      let!(:chapter) { FactoryBot.create(:chapter, sequence: 10, course: course) }

      before do
        FactoryBot.create(:chapter, sequence: 1, course: course)
        FactoryBot.create(:unit, sequence: 10, chapter: chapter)
        FactoryBot.create(:unit, sequence: 1, chapter: chapter)
      end

      it 'returns all courses with chapters, units order by sequence.' do
        query_result = Course.includes(chapters: :units).order(:id).order('chapters.sequence asc, units.sequence asc')
        expect(do_get.body).to eq(CoursePrinter.render(query_result, view: :with_chapters_and_units))
      end
    end
  end

  describe 'GET /courses/:id' do
    subject(:do_get) do
      get "/courses/#{course.id}"
      response
    end

    let!(:course) { FactoryBot.create(:course) }
    let!(:chapter) { FactoryBot.create(:chapter, sequence: 10, course: course) }

    before do
      FactoryBot.create(:course, :with_chapter_and_unit)
      FactoryBot.create(:chapter, sequence: 1, course: course)
      FactoryBot.create(:unit, sequence: 10, chapter: chapter)
      FactoryBot.create(:unit, sequence: 1, chapter: chapter)
    end

    it 'returns a 200' do
      expect(do_get).to have_http_status(:ok)
    end

    it 'returns the course with chapters, units ordered and CoursePrinter wrapped.' do
      query_result = Course.includes(chapters: :units).order('chapters.sequence asc, units.sequence asc').find(course.id)
      expect(do_get.body).to eq(CoursePrinter.render(query_result, view: :with_chapters_and_units))
    end
  end

  describe 'POST /courses' do
    subject(:do_post) do
      post '/courses', params: { course: course_params }
      response
    end

    let(:course_params) { FactoryBot.attributes_for(:course) }

    it 'returns a 201' do
      expect(do_post).to have_http_status(:created)
    end

    it 'creates a course' do
      expect { do_post }.to change(Course, :count).by(1)
    end

    context 'when the course has chapters and units' do
      let(:course_params) do
        {
          name: 'Course Title',
          lecturer: 'lecturer name',
          chapters_attributes: [
            {
              name: 'Chapter 1',
              units_attributes: [
                {
                  name: 'Unit 1.1',
                  content: 'Unit Content 1.1'
                },
                {
                  name: 'Unit 1.2',
                  content: 'Unit Content 1.2'

                }
              ]
            }
          ]
        }
      end

      it 'returns a 201' do
        expect(do_post).to have_http_status(:created)
      end

      it 'creates the course and its chapters and units' do
        expect { do_post }
          .to change(Course, :count).by(1)
          .and change(Chapter, :count).by(1)
          .and change(Unit, :count).by(2)
      end
    end
  end

  describe 'PATCH/PUT /courses/:id' do
    subject(:do_put) do
      put "/courses/#{course.id}", params: { course: course_params }
      response
    end

    let!(:course) { FactoryBot.create(:course, :with_chapter_and_unit) }
    let(:chapter) { course.chapters.first }
    let(:unit) { chapter.units.first }
    let(:course_params) do
      {
        name: 'Updated Course Title',
        lecturer: 'Updated lecturer name',
        chapters_attributes: [
          {
            id: chapter.id,
            name: 'Update Chapter 1',
            units_attributes: [
              {
                id: unit.id,
                name: 'Update Unit 1.1'
              }
            ]
          }
        ]
      }
    end

    it 'returns a 200' do
      expect(do_put).to have_http_status(:ok)
    end

    it 'updates the course, the chapter, and the unit' do
      expect { do_put }
        .to change { course.reload.name }.to('Updated Course Title')
        .and change { chapter.reload.name }.to('Update Chapter 1')
        .and change { unit.reload.name }.to('Update Unit 1.1')
    end

    context 'when adding a new chapter and a new unit' do
      let(:course_params) do
        {
          chapters_attributes: [
            {
              name: 'New Chapter 1',
              units_attributes: [
                {
                  name: 'New Unit 1.1',
                  content: 'New Unit content 1.1'
                }
              ]
            }
          ]
        }
      end

      it 'returns a 200' do
        expect(do_put).to have_http_status(:ok)
      end

      it 'creates a chapter and a units' do
        expect { do_put }
          .to change(Chapter, :count).by(1)
          .and change(Unit, :count).by(1)
      end
    end

    context 'when deleting existed chapter and unit' do
      let(:course_params) do
        {
          chapters_attributes: [
            {
              id: chapter.id,
              _destroy: true,
              units_attributes: [
                {
                  id: unit.id,
                  _destroy: true
                }
              ]
            }
          ]
        }
      end

      it 'returns a 200' do
        expect(do_put).to have_http_status(:ok)
      end

      it 'deletes the chapter and the unit' do
        expect { do_put }
          .to change(Chapter, :count).by(-1)
          .and change(Unit, :count).by(-1)
      end
    end

    context 'when update parameters not fitting format' do
      let(:course_params) do
        {
          chapters_attributes: [
            {
              id: chapter.id,
              name: nil,
              units_attributes: [
                {
                  id: unit.id,
                  name: nil
                }
              ]
            }
          ]
        }
      end

      it 'returns a 400' do
        expect(do_put).to have_http_status(:bad_request)
      end

      it 'returns error code PARAMETER_MISSING' do
        expect(do_put.body).to eq({ error_code: 'PARAMETER_MISSING' }.to_json)
      end
    end
  end

  describe 'DELETE /courses/:id' do
    subject(:do_delete) do
      delete "/courses/#{course.id}"
      response
    end

    let!(:course) { FactoryBot.create(:course) }

    it 'returns a 200' do
      expect(do_delete).to have_http_status(:ok)
    end

    it 'deletes the course' do
      expect { do_delete }.to change(Course, :count).by(-1)
    end

    context 'when the course has chapters and units' do
      let!(:course) { FactoryBot.create(:course, :with_chapter_and_unit) }

      it 'deletes the course and its chapters and units' do
        expect { do_delete }
          .to change(Course, :count).by(-1)
          .and change(Chapter, :count).by(-1)
          .and change(Unit, :count).by(-1)
      end
    end
  end
end
