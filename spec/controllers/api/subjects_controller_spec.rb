require 'spec_helper'

RSpec.describe Api::SubjectsController, type: :controller do
  let(:valid_attributes)  do
    {
      name: 'Introduction to Programming',
      code: 'CS101',
      description: 'Basic programming concepts',
      credits: 3
    }
  end

  let(:invalid_attributes) do
    {
      name: '',
      code: '',
      credits: 0
    }
  end

  let(:subject) { Subject.create!(valid_attributes) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all subjects' do
      subject1 = Subject.create!(name: 'Programming', code: 'CS101', credits: 3)
      subject2 = Subject.create!(name: 'Calculus', code: 'MATH101', credits: 4)
      
      get :index
      expect(assigns(:subjects)).to include(subject1, subject2)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: subject.id }
      expect(response).to be_successful
    end

    it 'returns the requested subject' do
      get :show, params: { id: subject.id }
      expect(assigns(:subject)).to eq(subject)
    end

    it 'returns not found for invalid id' do
      get :show, params: { id: 999999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Subject' do
        expect {
          post :create, params: { subject: valid_attributes }
        }.to change(Subject, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: { subject: valid_attributes }
        expect(response).to have_http_status(:created)
      end

      it 'returns the created subject' do
        post :create, params: { subject: valid_attributes }
        expect(assigns(:subject)).to be_persisted
        expect(assigns(:subject).name).to eq('Introduction to Programming')
        expect(assigns(:subject).code).to eq('CS101')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Subject' do
        expect {
          post :create, params: { subject: invalid_attributes }
        }.not_to change(Subject, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: { subject: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation errors' do
        post :create, params: { subject: invalid_attributes }
        expect(assigns(:subject).errors).to be_present
      end
    end

    context 'with duplicate code' do
      before { Subject.create!(valid_attributes) }

      it 'does not create a duplicate subject' do
        expect {
          post :create, params: { subject: valid_attributes }
        }.not_to change(Subject, :count)
      end

      it 'returns validation error for duplicate code' do
        post :create, params: { subject: valid_attributes }
        expect(assigns(:subject).errors[:code]).to include('has already been taken')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'Advanced Programming',
          credits: 4
        }
      end

      it 'updates the requested subject' do
        put :update, params: { id: subject.id, subject: new_attributes }
        subject.reload
        expect(subject.name).to eq('Advanced Programming')
        expect(subject.credits).to eq(4)
      end

      it 'returns a successful response' do
        put :update, params: { id: subject.id, subject: new_attributes }
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity status' do
        put :update, params: { id: subject.id, subject: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the subject' do
        original_name = subject.name
        put :update, params: { id: subject.id, subject: invalid_attributes }
        subject.reload
        expect(subject.name).to eq(original_name)
      end
    end

    it 'returns not found for invalid id' do
      put :update, params: { id: 999999, subject: valid_attributes }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested subject' do
      subject_to_delete = Subject.create!(valid_attributes)
      expect {
        delete :destroy, params: { id: subject_to_delete.id }
      }.to change(Subject, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: subject.id }
      expect(response).to be_successful
    end

    it 'returns not found for invalid id' do
      delete :destroy, params: { id: 999999 }
      expect(response).to have_http_status(:not_found)
    end

  end
end
