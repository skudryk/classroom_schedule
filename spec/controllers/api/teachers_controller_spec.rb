require 'spec_helper'

RSpec.describe Api::TeachersController, type: :controller do
  let(:valid_attributes) do
    {
      name: 'John Doe',
      email: 'john.doe@example.com',
      department: 'Computer Science',
      phone: '555-0123'
    }
  end

  let(:invalid_attributes) do
    {
      name: '',
      email: 'invalid-email',
      department: ''
    }
  end

  let(:teacher) { Teacher.create!(valid_attributes) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all teachers' do
      teacher1 = Teacher.create!(name: 'John Doe', email: 'john@example.com', department: 'CS')
      teacher2 = Teacher.create!(name: 'Jane Smith', email: 'jane@example.com', department: 'Math')
      
      get :index
      expect(assigns(:teachers)).to include(teacher1, teacher2)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: teacher.id }
      expect(response).to be_successful
    end

    it 'returns the requested teacher' do
      get :show, params: { id: teacher.id }
      expect(assigns(:teacher)).to eq(teacher)
    end

    it 'returns not found for invalid id' do
      get :show, params: { id: 999999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Teacher' do
        expect {
          post :create, params: { teacher: valid_attributes }
        }.to change(Teacher, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: { teacher: valid_attributes }
        expect(response).to have_http_status(:created)
      end

      it 'returns the created teacher' do
        post :create, params: { teacher: valid_attributes }
        expect(assigns(:teacher)).to be_persisted
        expect(assigns(:teacher).name).to eq('John Doe')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Teacher' do
        expect {
          post :create, params: { teacher: invalid_attributes }
        }.not_to change(Teacher, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: { teacher: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation errors' do
        post :create, params: { teacher: invalid_attributes }
        expect(assigns(:teacher).errors).to be_present
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        {
          name: 'John Smith',
          phone: '555-9999'
        }
      }

      it 'updates the requested teacher' do
        put :update, params: { id: teacher.id, teacher: new_attributes }
        teacher.reload
        expect(teacher.name).to eq('John Smith')
        expect(teacher.phone).to eq('555-9999')
      end

      it 'returns a successful response' do
        put :update, params: { id: teacher.id, teacher: new_attributes }
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity status' do
        put :update, params: { id: teacher.id, teacher: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the teacher' do
        original_name = teacher.name
        put :update, params: { id: teacher.id, teacher: invalid_attributes }
        teacher.reload
        expect(teacher.name).to eq(original_name)
      end
    end

    it 'returns not found for invalid id' do
      put :update, params: { id: 999999, teacher: valid_attributes }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested teacher' do
      teacher_to_delete = Teacher.create!(valid_attributes)
      expect {
        delete :destroy, params: { id: teacher_to_delete.id }
      }.to change(Teacher, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: teacher.id }
      expect(response).to be_successful
    end

    it 'returns not found for invalid id' do
      delete :destroy, params: { id: 999999 }
      expect(response).to have_http_status(:not_found)
    end

    context 'when teacher has associated sections' do
      let(:subject) { Subject.create!(name: 'Programming', code: 'CS101', credits: 3) }
      let(:classroom) { Classroom.create!(name: 'Lab A', building: 'Building 1', capacity: 25, room_number: '101') }
      
      it 'destroys the teacher and associated sections' do
        section = Section.create!(
          teacher: teacher,
          subject: subject,
          classroom: classroom,
          start_time: '09:00',
          end_time: '09:50',
          days_of_week: ['monday', 'wednesday', 'friday'],
          duration_minutes: 50,
          capacity: 25
        )

        expect {
          delete :destroy, params: { id: teacher.id }
        }.to change(Teacher, :count).by(-1)

        expect(Section.exists?(section.id)).to be false
      end
    end
  end

end
